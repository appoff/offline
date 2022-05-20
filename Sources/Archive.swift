import Foundation
import Archivable

public struct Archive: Arch {
    public var timestamp: UInt32
    public internal(set) var maps: [Map : Signature?]
    public internal(set) var settings: Settings

    public var data: Data {
        .init()
        .adding(UInt8(maps.count))
        .adding(maps
            .flatMap { item in
                Data()
                    .adding(item.key)
                    .adding(item.value != nil)
                    .adding(optional: item.value)
            })
        .adding(settings)
    }
    
    public init() {
        timestamp = 0
        maps = [:]
        settings = .init()
    }
    
    public init(version: UInt8, timestamp: UInt32, data: Data) async {
        var data = data
        self.timestamp = timestamp
        
        if version == Self.version {
            maps = (0 ..< .init(data.number() as UInt8))
                .reduce(into: [:]) { result, _ in
                    result[.init(data: &data)] = data.bool() ? .init(data: &data) : nil
                }
            settings = .init(data: &data)
        } else {
            maps = [:]
            settings = .init()
        }
    }
}
