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
}
