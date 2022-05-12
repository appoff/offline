import XCTest
@testable import Archivable
@testable import Offline

final class CloudTests: XCTestCase {
    private var cloud: Cloud<Archive, MockContainer>!
    
    override func setUp() {
        cloud = .init()
    }
    
    func testAddMap() async {
        let map = Map(title: "asd", origin: "fds", destination: "hre", distance: 3432, duration: 563)
        await cloud.add(map: map)
        
        var value = await cloud.model.maps
        XCTAssertEqual(1, value.count)
        
        await cloud.add(map: map)
        value = await cloud.model.maps
        XCTAssertEqual(1, value.count)
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
