import XCTest
@testable import Archivable
@testable import Offline

final class ArchiveTests: XCTestCase {
    private var archive: Archive!
    
    override func setUp() {
        archive = .init()
    }
    
    func testSettings() async {
        XCTAssertEqual(.auto, archive.settings.scheme)
        XCTAssertEqual(.standard, archive.settings.map)
        XCTAssertEqual(.walking, archive.settings.directions)
        XCTAssertTrue(archive.settings.interest)
        XCTAssertFalse(archive.settings.rotate)
        
        archive.settings.scheme = .dark
        archive.settings.map = .emphasis
        archive.settings.directions = .driving
        archive.settings.interest = false
        archive.settings.rotate = true
        archive = await Archive.prototype(data: archive.compressed)
        
        XCTAssertEqual(.dark, archive.settings.scheme)
        XCTAssertEqual(.emphasis, archive.settings.map)
        XCTAssertEqual(.driving, archive.settings.directions)
        XCTAssertFalse(archive.settings.interest)
        XCTAssertTrue(archive.settings.rotate)
    }
    
    func testMaps() async {
        let map1 = Header(title: "Some", origin: "a", destination: "b", distance: 1, duration: 1)
        let map2 = Header(title: "abc", origin: "fsd", destination: "465645", distance: 3, duration: 3)
        let schema = Schema(settings: .init(), thumbnail: .init(), points: [], tiles: [:])
        archive.projects.append(.init(header: map1, schema: schema))
        archive.projects.append(.init(header: map2, schema: nil))
        archive = await Archive.prototype(data: archive.compressed)
        XCTAssertEqual(2, archive.projects.count)
        XCTAssertEqual(map1.id, archive.projects.first?.id)
        XCTAssertEqual(map2.id, archive.projects.last?.id)
        XCTAssertNil(archive.projects.last?.schema)
        XCTAssertNotNil(archive.projects.first?.schema)
    }
}
