#if os(iOS) || os(macOS)
import MapKit

extension MKMapSnapshotter.Options {
    func configure(settings: Settings) -> Self {
        pointOfInterestFilter = settings.interest ? .includingAll : .excludingAll
        
        switch settings.map {
        case .standard:
            mapType = .standard
        case .satellite:
            mapType = .satelliteFlyover
        case .hybrid:
            mapType = .hybridFlyover
        case .emphasis:
            mapType = .mutedStandard
        }
        
#if os(iOS)
        var traits = [UITraitCollection]()
        traits.append(.init(displayScale: 2))
        
        switch settings.scheme {
        case .auto:
            break
        case .light:
            traits.append(.init(userInterfaceStyle: .light))
        case .dark:
            traits.append(.init(userInterfaceStyle: .dark))
        }
        
        traitCollection = .init(traitsFrom: traits)
#elseif os(macOS)
        switch settings.scheme {
        case .auto:
            break
        case .light:
            appearance = .init(named: .aqua)
        case .dark:
            appearance = .init(named: .darkAqua)
        }
#endif
        return self
    }
}
#endif
