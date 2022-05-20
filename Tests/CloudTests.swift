import XCTest
@testable import Archivable
@testable import Offline

final class CloudTests: XCTestCase {
    private var cloud: Cloud<Archive, MockContainer>!
    
    override func setUp() {
        cloud = .init()
    }
    
    func testAddMap() async {
        let signature = Signature(settings: .init(), thumbnail: .init(), points: [], tiles: [:])
        
        let map = Map(title: "asd", origin: "fds", destination: "hre", distance: 3432, duration: 563)
        await cloud.add(map: map, signature: nil)
        
        var value = await cloud.model
        XCTAssertEqual(1, value.maps.count)
        XCTAssertNil(value.maps.first?.signature)
        
        await cloud.add(map: map, signature: signature)
        value = await cloud.model
        XCTAssertEqual(1, value.maps.count)
        XCTAssertNotNil(value.maps.first?.signature)
    }
    
    func testDeleteMap() async {
        let map = Map(title: "asd", origin: "fds", destination: "hre", distance: 3432, duration: 563)
        await cloud.add(map: map, signature: nil)
        await cloud.delete(map: map)
        
        let value = await cloud.model
        XCTAssertTrue(value.maps.isEmpty)
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
        await cloud.update(directions: .driving)
        let value = await cloud.model.settings.directions
        XCTAssertEqual(.driving, value)
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
