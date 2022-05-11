import XCTest
@testable import Offline

final class ItemTests: XCTestCase {
    func testParse() async {
        let item = Item(origin: "Edinburgh", destination: "Glasgow", distance: 1234566, duration: 9876023)
        let parsed = item.data.prototype(Item.self)
        XCTAssertEqual(item.origin, parsed.origin)
        XCTAssertEqual(item.destination, parsed.destination)
        XCTAssertEqual(item.distance, parsed.distance)
        XCTAssertEqual(item.duration, parsed.duration)
    }
}
