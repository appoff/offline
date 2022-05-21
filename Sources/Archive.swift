import Foundation
import Archivable

public struct Archive: Arch {
    public var timestamp: UInt32
    public internal(set) var projects: [Project]
    public internal(set) var settings: Settings

    public var data: Data {
        .init()
        .adding(size: UInt8.self, collection: projects)
        .adding(settings)
    }
    
    public init() {
        timestamp = 0
        projects = []
        settings = .init()
    }
    
    public init(version: UInt8, timestamp: UInt32, data: Data) async {
        var data = data
        self.timestamp = timestamp
        
        if version == Self.version {
            projects = data.collection(size: UInt8.self)
            settings = .init(data: &data)
        } else {
            projects = []
            settings = .init()
        }
    }
}
