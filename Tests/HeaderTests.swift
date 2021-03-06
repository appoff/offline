import XCTest
@testable import Offline

final class HeaderTests: XCTestCase {
    func testParse() async {
        let map = Header(title: "Test", origin: "Edinburgh", destination: "Glasgow", distance: 14566, duration: 58723)
        let parsed = map.data.prototype(Header.self)
        XCTAssertEqual(map.id, parsed.id)
        XCTAssertEqual(map.title, parsed.title)
        XCTAssertEqual(map.origin, parsed.origin)
        XCTAssertEqual(map.destination, parsed.destination)
        XCTAssertEqual(map.distance, parsed.distance)
        XCTAssertEqual(map.duration, parsed.duration)
    }
    
    func testCap() {
        let text = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
"""
        
        let map = Header(title: text, origin: text, destination: text, distance: 14566, duration: 58723)
        
        XCTAssertLessThan(Data(map.title.utf8).count, 256)
        XCTAssertEqual("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor i", map.title)
        XCTAssertLessThan(Data(map.origin.utf8).count, 256)
        XCTAssertLessThan(Data(map.destination.utf8).count, 256)
        XCTAssertLessThan(map.data.count, 1000)
    }
    
    func testUnwrap() {
        let map = Header(title: "Test", origin: "Edinburgh", destination: "Glasgow", distance: 14566, duration: 58723)
        let parsed = Header.unwrap(data: map.wrapped)
        XCTAssertEqual(map.id, parsed?.id)
        XCTAssertEqual(map.title, parsed?.title)
        XCTAssertEqual(map.origin, parsed?.origin)
        XCTAssertEqual(map.destination, parsed?.destination)
        XCTAssertEqual(map.distance, parsed?.distance)
        XCTAssertEqual(map.duration, parsed?.duration)
    }
    
    func testUnwrapOther() {
        XCTAssertNoThrow(Header.unwrap(data: .init()))
        XCTAssertNoThrow(Header.unwrap(data: .init("".utf8)))
        XCTAssertNoThrow(Header.unwrap(data: .init("hello world lorem ipsum".utf8)))
        XCTAssertNoThrow(Header.unwrap(data: .init("offline".utf8)))
    }
}
