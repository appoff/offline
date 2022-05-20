import Foundation
import Archivable

public struct Item: Storable, Identifiable {
    public let map: Map
    public let signature: Signature?
    
    public var id: UUID {
        map.id
    }
    
    public var data: Data {
        .init()
        .adding(map)
        .adding(signature != nil)
        .adding(optional: signature)
    }
    
    public init(data: inout Data) {
        map = .init(data: &data)
        signature = data.bool() ? .init(data: &data) : nil
    }
    
    init(map: Map, signature: Signature?) {
        self.map = map
        self.signature = signature
    }
}
