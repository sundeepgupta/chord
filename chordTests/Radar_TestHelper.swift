@testable import chord
import CoreLocation
import CoreBluetooth


class FakeRadar: Radar {
    var started = false
    var stopped = false
    
    static func radar() -> FakeRadar {
        return FakeRadar(locationManager: CLLocationManager(), region: CLBeaconRegion(), responder: RadarResponder())
    }
    
    override func start() {
        self.started = true
    }
    
    override func stop() {
        self.stopped = true
    }
}


class FakeLocationManager: CLLocationManager {
    var region: CLRegion!
    var requestedAuthorization = false
    var startedMonitoring = false
    var stoppedMonitoring = false
    var startedRanging = false
    var stoppedRanging = false
    
    override func requestAlwaysAuthorization() {
        self.requestedAuthorization = true
    }
    
    override func startMonitoringForRegion(region: CLRegion) {
        self.startedMonitoring = true
        self.region = region
    }
    
    override func stopMonitoringForRegion(region: CLRegion) {
        self.stoppedMonitoring = true
        self.region = region
    }
    
    override func startRangingBeaconsInRegion(region: CLBeaconRegion) {
        self.startedRanging = true
        self.region = region
    }
    
    override func stopRangingBeaconsInRegion(region: CLBeaconRegion) {
        self.stoppedRanging = true
        self.region = region
    }
}