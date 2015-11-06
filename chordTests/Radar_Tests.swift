import XCTest
@testable import chord
import CoreLocation


class Radar_Tests: XCTestCase {
    var subject: Radar!
    var locationManager: FakeLocationManager!
    var region: CLBeaconRegion!
    var proximityReactionCalled = false
    
    override func setUp() {
        super.setUp()
        
        self.locationManager = FakeLocationManager()

        let UUID = NSUUID(UUIDString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")
        self.region = CLBeaconRegion(proximityUUID: UUID!, identifier: "abc")

        self.subject = Radar(locationManager: self.locationManager, region: self.region, responder: RadarResponder()) { (_, _) in
            self.proximityReactionCalled = true
        }
    }
    
    func testStarting() {
        self.subject.start()
        XCTAssertTrue(self.locationManager.requestedAuthorization)
        XCTAssertTrue(self.locationManager.startedMonitoring)
        XCTAssertEqual(locationManager.region, self.region)
    }
    
    func testStopsMonitoringWhenStopping() {
        self.subject.stop()
        XCTAssertTrue(self.locationManager.stoppedMonitoring)
        XCTAssertEqual(locationManager.region, self.region)
    }
    
    func testRespondingToAuthorizedRanging() {
        let subject = FakeRadar.radar()
        subject.userAuthorizedRanging()
        XCTAssertTrue(subject.started)
    }
    
    func testRespondingToRevokedRanging() {
        let subject = FakeRadar.radar()
        subject.userRevokedRanging()
        XCTAssertTrue(subject.stopped)
    }
    
    func testRespondingToFailedRanging() {
        let subject = FakeRadar.radar()
        subject.rangingFailed(NSError(domain: "", code: 0, userInfo: nil))
        XCTAssertTrue(subject.stopped)
    }
}