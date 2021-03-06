#if os(iOS) || os(macOS)
import MapKit

extension MKPointAnnotation {
    var thumbnail: MKMapSnapshotter.Options {
        let point = MKMapPoint(coordinate)
        let proportion = MKMapRect.world.width / pow(2, .init(17))
        let options = MKMapSnapshotter.Options()
        options.mapType = .standard
        options.size = .init(width: MKMapSnapshotter.Snapshot.thumbnail, height: MKMapSnapshotter.Snapshot.thumbnail)
        options.mapRect = .init(x: point.x - (proportion / 2),
                                y: point.y - (proportion / 4),
                                width: proportion,
                                height: proportion)
        return options
    }
}
#endif
