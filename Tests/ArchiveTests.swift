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
        archive.settings.directions = .transit
        archive.settings.interest = false
        archive.settings.rotate = true
        archive = await Archive.prototype(data: archive.compressed)
        
        XCTAssertEqual(.dark, archive.settings.scheme)
        XCTAssertEqual(.emphasis, archive.settings.map)
        XCTAssertEqual(.transit, archive.settings.directions)
        XCTAssertFalse(archive.settings.interest)
        XCTAssertTrue(archive.settings.rotate)
    }
    
    func testMaps() async {
        let map = Map(title: "Some", origin: "a", destination: "b", distance: 1, duration: 1)
        archive.maps.append(map)
        archive = await Archive.prototype(data: archive.compressed)
        XCTAssertEqual(map.id, archive.maps.first?.id)
    }
    
    func testThumbnails() async {
        let id = UUID()
        let image = Data("hello world".utf8)
        archive.thumbnails[id] = image
        archive = await Archive.prototype(data: archive.compressed)
        XCTAssertEqual(id, archive.thumbnails.first?.key)
        XCTAssertEqual(image, archive.thumbnails.first?.value)
    }
}
