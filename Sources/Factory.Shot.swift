#if os(iOS) || os(macOS)
import MapKit

extension Factory {
    struct Shot {
        static let tile = 256.0
        
        let x: Int
        let y: Int
        let z: Int
        let width: Int
        let height: Int
        private let proportion: Double
        
        init(x: Int, y: Int, z: Int, width: Int, height: Int, proportion: Double) {
            self.x = x
            self.y = y
            self.z = z
            self.width = width
            self.height = height
            self.proportion = proportion
        }
        
        var options: MKMapSnapshotter.Options {
            let options = MKMapSnapshotter.Options()
            options.size = .init(width: Self.tile * .init(width), height: Self.tile * .init(height))
            options.mapRect = .init(x: .init(x) * proportion,
                                    y: .init(y) * proportion,
                                    width: .init(width) * proportion,
                                    height: .init(height) * proportion)
            return options
        }
    }
}
#endif
