import MapKit
import Archivable

public struct Signature: Storable {
    public let route: [Route]
    public let settings: Settings
    public let thumbnail: Data
    let points: [Point]
    let content: Data
    
    public var tiles: Tiles {
        content.prototype()
    }
    
    public var annotations: [MKPointAnnotation] {
        points.map(\.annotation)
    }
    
    public var polyline: MKMultiPolyline {
        .init(route.map(\.polyline))
    }
    
    public var data: Data {
        .init()
        .adding(size: UInt8.self, collection: route)
        .adding(settings)
        .wrapping(size: UInt32.self, data: thumbnail)
        .adding(size: UInt8.self, collection: points)
        .wrapping(size: UInt16.self, data: content)
    }
    
    public init(data: inout Data) {
        route = data.collection(size: UInt8.self)
        settings = .init(data: &data)
        thumbnail = data.unwrap(size: UInt32.self)
        points = data.collection(size: UInt8.self)
        content = data.unwrap(size: UInt16.self)
    }
    
    init(route: [Route],
         settings: Settings,
         thumbnail: Data,
         points: [Point],
         tiles: [UInt8 : [UInt32 : [UInt32 : UInt32]]]) {
        self.route = route
        self.settings = settings
        self.thumbnail = thumbnail
        self.points = points
        content = Tiles(items: tiles).data
    }
}
