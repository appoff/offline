import XCTest
@testable import Offline

final class TilesTests: XCTestCase {
    func testParse() async {
        let z = 11
        let x = 45356
        let y = 892002
        let value = "hello world"
        let thumbnail = Data("lorem ipsum".utf8)
        let tiles = Tiles(thumbnail: thumbnail,
                          items: [.init(z) : [.init(x) : [.init(y) : .init(value.utf8)]]],
                          points: [.init(title: "hello", subtitle: "lorem", coordinate: .init(latitude: 1, longitude: 2))],
                          route: [.init(distance: 3, duration: 4, coordinates: [.init(latitude: 4, longitude: 5)])])
        let parsed = tiles.data.prototype(Tiles.self)
        XCTAssertEqual(value, String(decoding: parsed[x, y, z] ?? .init(), as: UTF8.self))
        XCTAssertEqual(thumbnail, tiles.thumbnail)
        XCTAssertEqual("hello", parsed.points.first?.title)
        XCTAssertEqual("lorem", parsed.points.first?.subtitle)
        XCTAssertEqual(1, parsed.points.first?.coordinate.latitude)
        XCTAssertEqual(2, parsed.points.first?.coordinate.longitude)
        XCTAssertEqual(3, parsed.route.first?.distance)
        XCTAssertEqual(4, parsed.route.first?.duration)
        XCTAssertEqual(4, parsed.route.first?.coordinates.first?.latitude)
        XCTAssertEqual(5, parsed.route.first?.coordinates.first?.longitude)
    }
}
