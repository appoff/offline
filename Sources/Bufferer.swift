import MapKit

private let buff = 100_000

public struct Bufferer {
    let tiles: Tiles
    private let input: InputStream
    private let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: buff)
    
    init(header: Header, tiles: Tiles) {
        self.tiles = tiles
        input = .init(url: Local().url(header: header))!
        input.open()
    }
    
    public func close() {
        print("bufferer gone")
        buffer.deallocate()
        input.close()
    }
    
    public func load(at: MKTileOverlayPath) async throws -> Data {
        print("offset: \(tiles[at.x, at.y, at.z])")
        
        guard let offset = tiles[at.x, at.y, at.z].map(Int.init) else { return .init() }
        
        var data = try await read(offset: offset, length: 4)
        let size = data.number() as UInt32
        print("size \(size)")
        return try await read(offset: offset + 4, length: .init(size))
    }
    
    @MainActor private func read(offset: Int, length: Int) throws -> Data {
        print("\(offset) : \(length)")
        input.setProperty(NSNumber(value: offset), forKey: .fileCurrentOffsetKey)
        
        var length = length
        var data = Data()
        
        repeat {
            let read = input.read(buffer, maxLength: min(buff, length))
            
            switch read {
            case 0, 1:
                throw NSError(domain: "", code: 1)
            default:
                data.append(buffer, count: read)
                length -= read
            }
        } while length > 0
        
        return data
    }
}
