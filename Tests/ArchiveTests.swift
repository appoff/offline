import XCTest
@testable import Archivable
@testable import Offline

final class ArchiveTests: XCTestCase {
    private var archive: Archive!
    
    override func setUp() {
        archive = .init()
    }
}
