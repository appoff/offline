import MapKit

private let tile = 256.0

extension Factory {
    struct Shot {
        private let x: Int
        private let y: Int
        private let z: Int
        private let width: Int
        private let height: Int
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
            options.mapType = .standard
            options.size = .init(width: tile * .init(width), height: tile * .init(height))
            options.mapRect = .init(x: .init(x) * proportion,
                                    y: .init(y) * proportion,
                                    width: .init(width) * proportion,
                                    height: .init(height) * proportion)
            return options
        }
    }
}
