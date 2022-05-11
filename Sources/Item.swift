import Foundation
import Archivable

public struct Item: Storable, Equatable {
    public static let offloaded = Item(origin: "", destination: "", distance: 0, duration: 0)
    
    public let origin: String
    public let destination: String
    public let distance: UInt32
    public let duration: UInt32
    
    public var data: Data {
        .init()
        .adding(size: UInt16.self, string: origin)
        .adding(size: UInt16.self, string: destination)
        .adding(distance)
        .adding(duration)
    }
    
    public init(data: inout Data) {
        origin = data.string(size: UInt16.self)
        destination = data.string(size: UInt16.self)
        distance = data.number()
        duration = data.number()
    }
    
    init(origin: String, destination: String, distance: UInt32, duration: UInt32) {
        self.origin = origin
        self.destination = destination
        self.distance = distance
        self.duration = duration
    }
}
