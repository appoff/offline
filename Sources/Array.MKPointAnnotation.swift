#if os(iOS) || os(macOS)
import MapKit

extension Array where Element == MKPointAnnotation {
    func points(with route: Set<Routing>) -> [Point] {
        map { point in
                .init(title: point.title ?? "",
                      subtitle: point.subtitle ?? "",
                      coordinate: point.coordinate.coordinate,
                      route: route
                    .first {
                        $0.origin == point
                    }?
                    .route
                    .route)
        }
    }
}
#endif
