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
    
    func testMap() async {
        await cloud.update(map: .emphasis)
        let value = await cloud.model.settings.map
        XCTAssertEqual(.emphasis, value)
    }
    
    func testInterest() async {
        await cloud.update(interest: false)
        let value = await cloud.model.settings.interest
        XCTAssertFalse(value)
    }
}
