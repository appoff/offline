import MapKit

private let buff = 100_000

public actor Bufferer {
    let tiles: Tiles
    private let input: InputStream
    private let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: buff)
    
    init(header: Header, tiles: Tiles) {
        self.tiles = tiles
        input = .init(url: Local().url(header: header))!
        input.open()
    }
    
    deinit {
        print("bufferer gone")
        buffer.deallocate()
        input.close()
    }
    
    public func load(at: MKTileOverlayPath) throws -> Data {
        guard let offset = tiles[at.x, at.y, at.z].map(Int.init) else { return .init() }
        
        var data = try read(offset: offset, length: 4)
        return try read(offset: offset + 4, length: .init(data.number() as UInt32))
    }
    
    private func read(offset: Int, length: Int) throws -> Data {
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
