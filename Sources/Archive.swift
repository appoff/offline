import Foundation
import Archivable

public struct Archive: Arch {
    public var timestamp: UInt32
    public internal(set) var settings: Settings

    public var data: Data {
        .init()
        .adding(settings)
    }
    
    public init() {
        timestamp = 0
        settings = .init()
    }
    
    public init(version: UInt8, timestamp: UInt32, data: Data) async {
        var data = data
        self.timestamp = timestamp
        
        if version == Self.version {
            settings = .init(data: &data)
        } else {
            settings = .init()
        }
    }
}
