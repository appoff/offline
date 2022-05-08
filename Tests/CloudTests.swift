import XCTest
@testable import Archivable
@testable import Offline

final class CloudTests: XCTestCase {
    private var cloud: Cloud<Archive, MockContainer>!
    
    override func setUp() {
        cloud = .init()
    }
    
    func testScheme() async {
        await cloud.update(scheme: .dark)
        let value = await cloud.model.settings.scheme
        XCTAssertEqual(.dark, value)
    }
}
