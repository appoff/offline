import Foundation
import Archivable

public struct Settings: Storable {
    public internal(set) var scheme: Scheme
    public internal(set) var map: Map
    public internal(set) var interest: Bool
    
    public var data: Data {
        .init()
        .adding(scheme.rawValue)
        .adding(map.rawValue)
        .adding(interest)
    }
    
    public init(data: inout Data) {
        scheme = .init(rawValue: data.removeFirst())!
        map = .init(rawValue: data.removeFirst())!
        interest = data.bool()
    }
    
    init() {
        scheme = .auto
        map = .standard
        interest = true
    }
}
