import MapKit

extension MKMapSnapshotter.Options {
    func configure(settings: Settings) -> Self {
#if os(iOS)
        traitCollection = .init(traitsFrom: [.init(displayScale: 2), .init(userInterfaceStyle: .light)])
#elseif os(macOS)
        appearance = NSAppearance(named: .darkAqua)
#endif
        return self
    }
}
