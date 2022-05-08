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
        
        archive.settings.scheme = .dark
        archive.settings.map = .emphasis
        archive = await Archive.prototype(data: archive.compressed)
        
        XCTAssertEqual(.dark, archive.settings.scheme)
        XCTAssertEqual(.emphasis, archive.settings.map)
    }
}
