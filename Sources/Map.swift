import Foundation
import Archivable

public struct Map: Storable, Equatable {
    public static let offloaded = Self(content: .init())
    
    private let content: Data
//    public let title: String
//    public let origin: String
//    public let destination: String
//    public let distance: UInt8
//    public let duration: UInt8
    
    public var tiles: Tiles {
        content.prototype()
    }
    
    public var data: Data {
        .init()
    }
    
    public init(data: inout Data) {
        content = .init()
    }
    
    init(tiles: Tiles) {
        self.init(content: tiles.data)
    }
    
    private init(content: Data) {
        self.content = content
    }
}
