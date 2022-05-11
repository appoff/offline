import Foundation
import Archivable

public struct Code: Storable, Identifiable {
    public let id: UUID
    public let title: String
    
    public var data: Data {
        .init()
        .adding(id)
        .adding(size: UInt8.self, string: title)
    }
    
    public init(data: inout Data) {
        id = data.uuid()
        title = data.string(size: UInt8.self)
    }
}
