import Foundation
import Archivable

struct Package: Storable {
    let schema: Schema
    let content: Data
    
    var data: Data {
        .init()
        .adding(schema)
        .wrapping(size: UInt32.self, data: content)
    }
    
    init(data: inout Data) {
        schema = .init(data: &data)
        content = data.unwrap(size: UInt32.self)
    }
}
