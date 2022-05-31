import Foundation
import Archivable

private let header = "offline"
private let size = 7

public struct Header: Storable, Identifiable {
    public let id: UUID
    public let title: String
    public let origin: String
    public let destination: String
    public let distance: UInt16
    public let duration: UInt16
    
    public static func unwrap(data: Data) -> Self? {
        guard
            data.count > size,
            data[0 ..< size] == Data(header.utf8)
        else { return nil }
        return data[size ..< data.count].prototype()
    }
    
    public var wrapped: Data {
        Data(header.utf8) + data
    }
    
    public var data: Data {
        .init()
        .adding(id)
        .adding(size: UInt8.self, string: title)
        .adding(size: UInt8.self, string: origin)
        .adding(size: UInt8.self, string: destination)
        .adding(distance)
        .adding(duration)
    }
    
    public init(data: inout Data) {
        id = data.uuid()
        title = data.string(size: UInt8.self)
        origin = data.string(size: UInt8.self)
        destination = data.string(size: UInt8.self)
        distance = data.number()
        duration = data.number()
    }
    
    public init(title: String, origin: String, destination: String, distance: UInt16, duration: UInt16) {
        id = .init()
        self.title = title.max8
        self.origin = origin.max8
        self.destination = destination.max8
        self.distance = distance
        self.duration = duration
    }
}
