import XCTest
@testable import Archivable
@testable import Offline

final class CloudTests: XCTestCase {
    private var cloud: Cloud<Archive, MockContainer>!
    
    override func setUp() {
        cloud = .init()
    }
    
    func testAddMap() async {
        let schema = Schema(settings: .init(), thumbnail: .init(), points: [], tiles: [:])
        
        let map = Header(title: "asd", origin: "fds", destination: "hre", distance: 3432, duration: 563)
        await cloud.add(header: map, schema: nil)
        
        var value = await cloud.model
        XCTAssertEqual(1, value.projects.count)
        XCTAssertNil(value.projects.first?.schema)
        
        await cloud.add(header: map, schema: schema)
        value = await cloud.model
        XCTAssertEqual(1, value.projects.count)
        XCTAssertNotNil(value.projects.first?.schema)
    }
    
    func testDeleteMap() async {
        let map = Header(title: "asd", origin: "fds", destination: "hre", distance: 3432, duration: 563)
        await cloud.add(header: map, schema: nil)
        await cloud.delete(header: map)
        
        let value = await cloud.model
        XCTAssertTrue(value.projects.isEmpty)
    }
    
    func testOffloadMap() async {
        let header = Header(title: "asd", origin: "fds", destination: "hre", distance: 3432, duration: 563)
        await cloud.add(header: header, schema: .init(settings: .init(), thumbnail: .init(), points: [], tiles: [:]))
        await cloud.add(header: .init(title: "", origin: "", destination: "", distance: 0, duration: 0), schema: nil)
        
        var value = await cloud.model
        XCTAssertNotNil(value.projects[1].schema)
        
        await cloud.offload(header: header)
        value = await cloud.model
        XCTAssertEqual(header.id, value.projects[1].header.id)
        XCTAssertNil(value.projects[1].schema)
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
