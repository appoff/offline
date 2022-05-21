import XCTest
@testable import Offline

final class SignatureTests: XCTestCase {
    func testParse() async {
        var settings = Settings()
        settings.map = .emphasis
        
        let z = 11
        let x = 45356
        let y = 892002
        let offset = UInt32(3252342342)
        
        let thumbnail = Data("lorem ipsum".utf8)
        let signature = Signature(
            settings: settings,
            thumbnail: thumbnail,
            points: [.init(title: "hello",
                           subtitle: "lorem",
                           coordinate: .init(latitude: 1, longitude: 2),
                           route: .init(distance: 3, duration: 4, coordinates: [.init(latitude: 4, longitude: 5)])),
                     .init(title: "a123",
                                    subtitle: "ffs",
                                    coordinate: .init(latitude: 3, longitude: 4),
                                    route: nil)
            ],
            tiles: [.init(z) : [.init(x) : [.init(y) : offset]]])
        
        let parsed = signature.data.prototype(Signature.self)
        let tiles = parsed.tiles
        XCTAssertEqual(offset, .init(tiles[x, y, z] ?? 0))
        XCTAssertEqual(thumbnail, signature.thumbnail)
        XCTAssertEqual("hello", parsed.points.first?.title)
        XCTAssertEqual("lorem", parsed.points.first?.subtitle)
        XCTAssertEqual(1, parsed.points.first?.coordinate.latitude)
        XCTAssertEqual(2, parsed.points.first?.coordinate.longitude)
        XCTAssertEqual(3, parsed.points.first?.route?.distance)
        XCTAssertEqual(4, parsed.points.first?.route?.duration)
        XCTAssertEqual(4, parsed.points.first?.route?.coordinates.first?.latitude)
        XCTAssertEqual(5, parsed.points.first?.route?.coordinates.first?.longitude)
        XCTAssertNil(parsed.points.last?.route)
        XCTAssertEqual(.emphasis, parsed.settings.map)
    }
}
