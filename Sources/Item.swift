import Foundation
import Archivable

public struct Item: Storable, Identifiable {
    public let map: Map
    public let schema: Schema?
    
    public var id: UUID {
        map.id
    }
    
    public var data: Data {
        .init()
        .adding(map)
        .adding(schema != nil)
        .adding(optional: schema)
    }
    
    public init(data: inout Data) {
        map = .init(data: &data)
        schema = data.bool() ? .init(data: &data) : nil
    }
    
    public func contains(tokens: [String]) -> Bool {
        tokens
            .contains { token in
                map.title.localizedCaseInsensitiveContains(token)
                || map.origin.localizedCaseInsensitiveContains(token)
                || map.destination.localizedCaseInsensitiveContains(token)
            }
    }
    
    init(map: Map, schema: Schema?) {
        self.map = map
        self.schema = schema
    }
}
