import Foundation
import Archivable

struct Package: Storable {
    let signature: Signature
    let content: Data
    
    var data: Data {
        .init()
        .adding(signature)
        .wrapping(size: UInt32.self, data: content)
    }
    
    init(data: inout Data) {
        signature = .init(data: &data)
        content = data.unwrap(size: UInt32.self)
    }
}
