import XCTest
@testable import chord
import CoreBluetooth
import CoreLocation


class RadarFactoryTests: XCTestCase {
    func testValidUuid() {
        let uuid = "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"
        XCTAssertNotNil(RadarFactory.radar(uuid))
    }
    
    func testInValidUuid() {
        let uuid = "bla"
        XCTAssertNil(RadarFactory.radar(uuid))
    }
}
