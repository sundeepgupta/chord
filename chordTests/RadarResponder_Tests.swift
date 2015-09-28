import XCTest
@testable import chord
import CoreLocation


class RadarResponder_Tests: XCTestCase {
    var subject: RadarResponder!
    var radar: FakeRadar!
    var locationManager: FakeLocationManager!
    var region: CLBeaconRegion!
    
    override func setUp() {
        super.setUp()
        
        self.subject = RadarResponder()
        self.radar = FakeRadar.radar()
        self.subject.delegate = self.radar
        self.locationManager = FakeLocationManager()
        let UUID = NSUUID(UUIDString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")
        self.region = CLBeaconRegion(proximityUUID: UUID!, identifier: "abc")
    }
    
    
    func testStartRangingWhenInsideRegion() {
        self.subject.locationManager(self.locationManager, didDetermineState: .Inside, forRegion: self.region)
        
        XCTAssertTrue(self.locationManager.startedRanging)
        XCTAssertEqual(self.region, self.locationManager.region)
    }
    
    func testStopRangingWhenOutsideRegion() {
        self.subject.locationManager(self.locationManager, didDetermineState: .Outside, forRegion: self.region)
        
        XCTAssertTrue(self.locationManager.stoppedRanging)
        XCTAssertEqual(self.region, self.locationManager.region)
    }
    
    func testStopRangingWhenUnknownRegion() {
        self.subject.locationManager(self.locationManager, didDetermineState: .Unknown, forRegion: self.region)
        
        XCTAssertTrue(self.locationManager.stoppedRanging)
        XCTAssertEqual(self.region, self.locationManager.region)
    }
    
    
    // Why do these fail only when testing the entire suite?
    func testUserAuthorizedRanging() {
        self.subject.locationManager(self.locationManager, didChangeAuthorizationStatus: .AuthorizedAlways)
        XCTAssertTrue(self.radar.userAuthorized)
    }
    
    func testUserDidNotAuthorizeRanging() {
        self.subject.locationManager(self.locationManager, didChangeAuthorizationStatus: .AuthorizedWhenInUse)
        XCTAssertTrue(self.radar.userRevoked)
    }
}
