import XCTest
@testable import Offline

final class MapTests: XCTestCase {
    func testParse() async {
        let map = Map(title: "Test", origin: "Edinburgh", destination: "Glasgow", distance: 1234566, duration: 9876023)
        let parsed = map.data.prototype(Map.self)
        XCTAssertEqual(map.title, parsed.title)
        XCTAssertEqual(map.origin, parsed.origin)
        XCTAssertEqual(map.destination, parsed.destination)
        XCTAssertEqual(map.distance, parsed.distance)
        XCTAssertEqual(map.duration, parsed.duration)
    }
}
