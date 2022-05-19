import Foundation
import Archivable

public struct Settings: Storable {
    public var scheme: Scheme
    public internal(set) var map: Map
    public internal(set) var directions: Directions
    public internal(set) var interest: Bool
    public internal(set) var rotate: Bool
    
    public var data: Data {
        .init()
        .adding(scheme.rawValue)
        .adding(map.rawValue)
        .adding(directions.rawValue)
        .adding(interest)
        .adding(rotate)
    }
    
    public init(data: inout Data) {
        scheme = .init(rawValue: data.removeFirst())!
        map = .init(rawValue: data.removeFirst())!
        directions = .init(rawValue: data.removeFirst())!
        interest = data.bool()
        rotate = data.bool()
    }
    
    init() {
        scheme = .auto
        map = .standard
        directions = .walking
        interest = true
        rotate = false
    }
}
