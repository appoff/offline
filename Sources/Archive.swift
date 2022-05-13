import Foundation
import Archivable

public struct Archive: Arch {
    public var timestamp: UInt32
    public internal(set) var maps: [Map]
    public internal(set) var thumbnails: [UUID : Data]
    public internal(set) var settings: Settings

    public var data: Data {
        .init()
        .adding(size: UInt8.self, collection: maps)
        .adding(UInt8(thumbnails.count))
        .adding(thumbnails
            .flatMap {
                Data()
                    .adding($0.key)
                    .wrapping(size: UInt32.self, data: $0.value)
            })
        .adding(settings)
    }
    
    public init() {
        timestamp = 0
        maps = []
        thumbnails = [:]
        settings = .init()
    }
    
    public init(version: UInt8, timestamp: UInt32, data: Data) async {
        var data = data
        self.timestamp = timestamp
        
        if version == Self.version {
            maps = data.collection(size: UInt8.self)
            thumbnails = (0 ..< .init(data.number() as UInt8))
                .reduce(into: [:]) { result, _ in
                    result[data.uuid()] = data.unwrap(size: UInt32.self)
                }
            settings = .init(data: &data)
        } else {
            maps = []
            thumbnails = [:]
            settings = .init()
        }
    }
}
