import MapKit

public struct Routing: Hashable {
    public let origin: MKPointAnnotation
    public let destination: MKPointAnnotation
    public let route: MKRoute
}
