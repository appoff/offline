import Foundation
import Archivable

public struct Header: Storable, Identifiable {
    public let id: UUID
    public let title: String
    public let origin: String
    public let destination: String
    public let distance: UInt32
    public let duration: UInt32
    let date: UInt32
    
    public var data: Data {
        .init()
        .adding(id)
        .adding(size: UInt8.self, string: title)
        .adding(size: UInt8.self, string: origin)
        .adding(size: UInt8.self, string: destination)
        .adding(distance)
        .adding(duration)
        .adding(date)
    }
    
    public init(data: inout Data) {
        id = data.uuid()
        title = data.string(size: UInt8.self)
        origin = data.string(size: UInt8.self)
        destination = data.string(size: UInt8.self)
        distance = data.number()
        duration = data.number()
        date = data.number()
    }
    
    public init(title: String, origin: String, destination: String, distance: UInt32, duration: UInt32) {
        id = .init()
        self.title = title.max8
        self.origin = origin.max8
        self.destination = destination.max8
        self.distance = distance
        self.duration = duration
        self.date = Date().timestamp
    }
}
