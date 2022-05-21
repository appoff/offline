import Foundation
import Archivable

public struct Project: Storable, Identifiable {
    public let header: Header
    public let schema: Schema?
    
    public var id: UUID {
        header.id
    }
    
    public var bufferer: Bufferer? {
        schema
            .map {
                .init(header: header, tiles: $0.tiles.prototype())
            }
    }
    
    public var data: Data {
        .init()
        .adding(header)
        .adding(schema != nil)
        .adding(optional: schema)
    }
    
    public init(data: inout Data) {
        header = .init(data: &data)
        schema = data.bool() ? .init(data: &data) : nil
    }
    
    public func contains(tokens: [String]) -> Bool {
        tokens
            .contains { token in
                header.title.localizedCaseInsensitiveContains(token)
                || header.origin.localizedCaseInsensitiveContains(token)
                || header.destination.localizedCaseInsensitiveContains(token)
            }
    }
    
    init(header: Header, schema: Schema?) {
        self.header = header
        self.schema = schema
    }
}
