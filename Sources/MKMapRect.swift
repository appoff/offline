import MapKit
import Archivable

private let padding = 2

extension MKMapRect {
    var shots: [Factory.Shot] {
        (13 ... 19)
            .flatMap { z -> [Factory.Shot] in
                let max = 10
                let proportion = MKMapRect.world.width / pow(2, .init(z))
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
        + thumbnail
    }
    
    private var thumbnail: Factory.Shot {
        let z = 10
        let proportion = MKMapRect.world.width / pow(2, .init(z))
        let x = Int(midX / proportion)
        let y = Int(midY / proportion)
        
        return .init(x: x - 1,
                     y: y,
                     z: z,
                     width: 1,
                     height: 1,
                     proportion: proportion)
    }
}
