import XCTest
@testable import Archivable
@testable import Offline

final class CloudTests: XCTestCase {
    private var cloud: Cloud<Archive, MockContainer>!
    
    override func setUp() {
        cloud = .init()
    }
    
    func testAddMap() async {
        let data = Data("hello world".utf8)
        let tiles = Tiles(thumbnail: data, items: [0 : [0 : [0 : .init()]]])
        let map1 = Map(title: "asd", origin: "fds", destination: "hre", distance: 3432, duration: 563)
        await cloud.add(map: map1, tiles: tiles)
        
        var value = await cloud.model
        XCTAssertEqual(1, value.maps.count)
        XCTAssertEqual(data, value.thumbnails.first?.value)
        XCTAssertEqual(data, value.thumbnails[map1.id])
        
        await cloud.add(map: map1, tiles: tiles)
        value = await cloud.model
        XCTAssertEqual(1, value.maps.count)
        
        
        let map2 = Map(title: "hello", origin: "", destination: "", distance: 0, duration: 0)
        await cloud.add(map: map2, tiles: tiles)
        value = await cloud.model
        XCTAssertEqual(2, value.maps.count)
        XCTAssertEqual(2, value.thumbnails.count)
        XCTAssertEqual(map2, value.maps.first)
    }
    
    func testScheme() async {
        await cloud.update(scheme: .dark)
        let value = await cloud.model.settings.scheme
        XCTAssertEqual(.dark, value)
    }
    
    func testMap() async {
        await cloud.update(map: .emphasis)
        let value = await cloud.model.settings.map
        XCTAssertEqual(.emphasis, value)
    }
    
    func testDirections() async {
        await cloud.update(directions: .transit)
        let value = await cloud.model.settings.directions
        XCTAssertEqual(.transit, value)
    }
    
    func testInterest() async {
        await cloud.update(interest: false)
        let value = await cloud.model.settings.interest
        XCTAssertFalse(value)
    }
    
    func testRotate() async {
        await cloud.update(rotate: true)
        let value = await cloud.model.settings.rotate
        XCTAssertTrue(value)
    }
}
