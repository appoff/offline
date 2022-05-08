import Foundation
import Archivable

public struct Settings: Storable {
    public internal(set) var scheme: Scheme
    
    public var data: Data {
        .init()
        .adding(scheme.rawValue)
    }
    
    public init(data: inout Data) {
        scheme = .init(rawValue: data.removeFirst())!
    }
    
    init() {
        scheme = .auto
    }
}
