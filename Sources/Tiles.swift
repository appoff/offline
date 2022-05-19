import MapKit
import Archivable

public struct Tiles: Storable {
    public let settings: Settings
    let points: [Point]
    let route: [Route]
    let thumbnail: Data
    private let items: [UInt8 : [UInt32 : [UInt32 : Data]]]
    
    public var annotations: [MKPointAnnotation] {
        points.map(\.annotation)
    }
    
    public var polyline: MKMultiPolyline {
        .init(route.map(\.polyline))
    }
    
    public var data: Data {
        .init()
        .adding(size: UInt8.self, collection: points)
        .adding(size: UInt8.self, collection: route)
        .adding(settings)
        .wrapping(size: UInt32.self, data: thumbnail)
        .adding(UInt8(items.count))
        .adding(items
            .flatMap { z in
                Data()
                    .adding(z.key)
                    .adding(UInt16(z.value.count))
                    .adding(z
                        .value
                        .flatMap { x in
                            Data()
                                .adding(x.key)
                                .adding(UInt16(x.value.count))
                                .adding(x
                                    .value
                                    .flatMap { y in
                                        Data()
                                            .adding(y.key)
                                            .wrapping(size: UInt32.self, data: y.value)
                                    })
                        })
            })
    }
    
    public init(data: inout Data) {
        points = data.collection(size: UInt8.self)
        route = data.collection(size: UInt8.self)
        settings = .init(data: &data)
        thumbnail = data.unwrap(size: UInt32.self)
        items = (0 ..< .init(data.number() as UInt8))
            .reduce(into: [:]) { z, _ in
                z[data.number()] = (0 ..< .init(data.number() as UInt16))
                    .reduce(into: [:]) { x, _ in
                        x[data.number()] = (0 ..< .init(data.number() as UInt16))
                            .reduce(into: [:]) { y, _ in
                                y[data.number()] = data.unwrap(size: UInt32.self)
                            }
                    }
            }
    }
    
    init(thumbnail: Data,
         items: [UInt8 : [UInt32 : [UInt32 : Data]]],
         points: [Point],
         route: [Route],
         settings: Settings) {
        self.thumbnail = thumbnail
        self.items = items
        self.points = points
        self.route = route
        self.settings = settings
    }
    
    public subscript(x: Int, y: Int, z: Int) -> Data? {
        items[.init(z)]?[.init(x)]?[.init(y)]
    }
}
