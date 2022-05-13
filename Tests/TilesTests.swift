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
    
    func testThumbnail() async {
        let value1 = Data("hello world".utf8)
        let value2 = Data("world".utf8)
        let value3 = Data("hello".utf8)
        
        XCTAssertEqual(value1,
                       Tiles(items: [1 : [0 : [0 : value2]],
                                     0 : [0 : [0 : value1]],
                                     3 : [0 : [0 : value3]]]).thumbnail)
    }
}
