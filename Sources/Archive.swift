import Foundation
import Archivable

public struct Archive: Arch {
    public var timestamp: UInt32
    public internal(set) var maps: [String]
    public internal(set) var settings: Settings
    var stored: [String : Map]

    public var data: Data {
        .init()
        .adding(settings)
    }
    
    public init() {
        timestamp = 0
        maps = []
        settings = .init()
        stored = [:]
    }
    
    public init(version: UInt8, timestamp: UInt32, data: Data) async {
        var data = data
        self.timestamp = timestamp
        
        if version == Self.version {
            maps = []
            settings = .init(data: &data)
            stored = [:]
        } else {
            maps = []
            settings = .init()
            stored = [:]
        }
    }
}
