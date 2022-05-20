import Foundation
import Archivable

public struct Archive: Arch {
    public var timestamp: UInt32
    public internal(set) var maps: [Item]
    public internal(set) var settings: Settings

    public var data: Data {
        .init()
        .adding(size: UInt8.self, collection: maps)
        .adding(settings)
    }
    
    public init() {
        timestamp = 0
        maps = []
        settings = .init()
    }
    
    public init(version: UInt8, timestamp: UInt32, data: Data) async {
        var data = data
        self.timestamp = timestamp
        
        if version == Self.version {
            maps = data.collection(size: UInt8.self)
            settings = .init(data: &data)
        } else {
            maps = []
            settings = .init()
        }
    }
}
