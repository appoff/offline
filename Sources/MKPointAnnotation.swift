import MapKit

private let tile = 256.0

extension MKPointAnnotation {
    var options: MKMapSnapshotter.Options {
        let point = MKMapPoint(coordinate)
        let proportion = MKMapRect.world.width / pow(2, .init(17))
        let options = MKMapSnapshotter.Options()
        options.mapType = .standard
        options.size = .init(width: tile, height: tile)
        options.mapRect = .init(x: point.x - (proportion / 2), y: point.y - (proportion / 2), width: proportion, height: proportion)
#if os(iOS)
        options.traitCollection = .init(traitsFrom: [.init(displayScale: 2), .init(userInterfaceStyle: .light)])
#elseif os(macOS)
        options.appearance = NSAppearance(named: .darkAqua)
#endif
        return options
    }
}
