import MapKit

extension MKPointAnnotation {
    var thumbnail: Factory.Shot {
        let point = MKMapPoint(coordinate)
        let z = 15
        let proportion = MKMapRect.world.width / pow(2, .init(z))
        let x = Int(point.x / proportion)
        let y = Int(point.y / proportion)
        
        return .init(x: x,
                     y: y,
                     z: z,
                     width: 1,
                     height: 1,
                     proportion: proportion)
    }
}
