import Foundation
import Archivable

public struct Archive: Arch {
    public var timestamp: UInt32

    public var data: Data {
        .init()
    }
    
    public init() {
        timestamp = 0
    }
    
    public init(version: UInt8, timestamp: UInt32, data: Data) async {
        self.timestamp = timestamp
        
        if version == Self.version {
            
        }
    }
}
