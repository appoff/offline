import Foundation
import CoreLocation

extension Set where Element == Routing {
    public var distance: CLLocationDistance {
        map(\.route.distance)
            .reduce(0, +)
    }
    
    public var duration: TimeInterval {
        map(\.route.expectedTravelTime)
            .reduce(0, +)
    }
}
