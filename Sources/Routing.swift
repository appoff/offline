#if os(iOS) || os(macOS)
import MapKit

public struct Routing: Hashable {
    public let origin: MKPointAnnotation
    public let destination: MKPointAnnotation
    public let route: MKRoute
    
    public init(origin: MKPointAnnotation, destination: MKPointAnnotation, route: MKRoute) {
        self.origin = origin
        self.destination = destination
        self.route = route
    }
}
#endif
