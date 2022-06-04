#if os(iOS) || os(macOS)
import Foundation

extension Factory {
    final actor Builder {
        let output: OutputStream
        private(set) var result = [UInt8 : [UInt32 : [UInt32 : UInt32]]]()
        private var offset = UInt32()
        
        init(url: URL) {
            output = .init(url: url, append: false)!
            output.open()
        }
        
        deinit {
            output.close()
        }
        
        func add(image: Data, z: Int, x: Int, y: Int) throws {
            let data = Data()
                .adding(UInt32(image.count))
                .adding(image)
            
            try write(data: data)
            
            result[.init(z), default: [:]][.init(x), default: [:]][.init(y)] = offset
            offset += .init(data.count)
        }
        
        private func write(data: Data) throws {
            var data = data
            var size = data.count
            
            repeat {
                let written = data
                    .withUnsafeBytes {
                        output.write($0.bindMemory(to: UInt8.self).baseAddress!, maxLength: size)
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
}
#endif
