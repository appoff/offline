import Foundation
import Archivable

public struct Map: Storable {
    private let tiles: [UInt8 : [UInt32 : [UInt32 : Data]]]
//    public let title: String
//    public let origin: String
//    public let destination: String
//    public let distance: UInt8
//    public let duration: UInt8
    
    public var data: Data {
        .init()
    }
    
    public init(data: inout Data) {
        tiles = [:]
    }
    
    public subscript(x: Int, y: Int, z: Int) -> Data? {
        nil
    }
}
