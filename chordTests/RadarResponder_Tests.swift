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
    
    func testUserAuthorizedRanging() {
        self.subject.locationManager(self.locationManager, didChangeAuthorizationStatus: .AuthorizedAlways)
        XCTAssertTrue(self.radar.started)
    }
    
    func testUserAuthorizeRangingNotAlways() {
        self.subject.locationManager(self.locationManager, didChangeAuthorizationStatus: .AuthorizedWhenInUse)
        XCTAssertTrue(self.radar.stopped)
    }
    
    func testUserDeniedRanging() {
        self.subject.locationManager(self.locationManager, didChangeAuthorizationStatus: .Denied)
        XCTAssertTrue(self.radar.stopped)
    }
    
    func testUserAuthorizeNotDetermined() {
        self.subject.locationManager(self.locationManager, didChangeAuthorizationStatus: .NotDetermined)
        XCTAssertTrue(self.radar.stopped)
    }
    
    func testUserDidNotAuthorizeRestricted() {
        self.subject.locationManager(self.locationManager, didChangeAuthorizationStatus: .Restricted)
        XCTAssertTrue(self.radar.stopped)
    }
    
    func testRangedBeacons() {
        let beacons = [CLBeacon(), CLBeacon()]
        self.subject.locationManager(self.locationManager, didRangeBeacons: beacons, inRegion: self.region)
        XCTAssertEqual(self.radar.beacons, beacons)
    }
}
