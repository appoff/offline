import XCTest
@testable import Offline

final class TilesTests: XCTestCase {
    func testParse() async {
        let z = 11
        let x = 45356
        let y = 892002
        let value = "hello world"
        let tiles = Tiles(items: [.init(z) : [.init(x) : [.init(y) : .init(value.utf8)]]])
        XCTAssertEqual(value, String(decoding: tiles.data.prototype(Tiles.self)[x, y, z] ?? .init(), as: UTF8.self))
    }
}
