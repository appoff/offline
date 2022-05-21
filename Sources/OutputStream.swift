import Foundation

extension OutputStream {
    func write(data: Data) throws {
        var data = data
        var size = data.count
        
        repeat {
            let written = data
                .withUnsafeBytes {
                    write($0.bindMemory(to: UInt8.self).baseAddress!, maxLength: size)
                }
            
            switch written {
            case 0, -1:
                throw NSError(domain: "", code: 1)
            default:
                size -= written
                
                if size > 0 {
                    data = data.suffix(size)
                }
            }
            
        } while size > 0
    }
}
