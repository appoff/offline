#if os(iOS) || os(macOS)
import MapKit

private let pad = 1

extension MKMapRect {
    var shots: [Factory.Shot] {
        (14 ... 19)
            .flatMap { z -> [Factory.Shot] in
                let max = 10
                let proportion = MKMapRect.world.width / pow(2, .init(z))
                let padding = z == 19 ? pad : 0
                let minY = Int(self.minY / proportion) - padding
                let maxX = Int(ceil(self.maxX / proportion)) + padding
                let maxY = Int(ceil(self.maxY / proportion)) + padding
                
                var shots = [Factory.Shot]()
                var minX = Int(self.minX / proportion) - padding
                
                while minX < maxX {
                    var y = minY
                    let width = min(maxX - minX, max - 1)
                    while y < maxY {
                        let height = min(maxY - y, max)
                        shots.append(.init(x: minX - 1,
                                           y: y,
                                           z: z,
                                           width: width + 1,
                                           height: height,
                                           proportion: proportion))
                        y += height
                    }
                    minX += width
                }
                
                return shots
            }
    }
}
#endif
