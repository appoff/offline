import Foundation

private let buff = 100_000

public final class Bufferer: InputStream {
    private let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: buff)
    
    public func read(offset: UInt32) throws -> Data {
        var size = try read(offset: .init(offset), length: MemoryLayout<UInt32>.size)
        return try read(offset: .init(offset) + MemoryLayout<UInt32>.size, length: .init(size.number() as UInt32))
    }
    
    private func read(offset: Int, length: Int) throws -> Data {
        setProperty(NSNumber(value: offset), forKey: .fileCurrentOffsetKey)
        
        var length = length
        var data = Data()
        
        repeat {
            let read = read(buffer, maxLength: min(buff, length))
            
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
