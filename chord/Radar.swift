import CoreBluetooth
import CoreLocation

class Radar: NSObject, RadarResponderDelegate {
    private let locationManager: CLLocationManager
    private let region: CLBeaconRegion
    private let responder: RadarResponder
    private var beaconActivities: [BeaconActivity] = []
    
    
    init(locationManager: CLLocationManager, region: CLBeaconRegion, responder: RadarResponder) {
        self.locationManager = locationManager
        self.region = region
        self.responder = responder
    }
    
    func start() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startMonitoringForRegion(self.region)
    }
    
    func stop() {
        self.locationManager.stopMonitoringForRegion(self.region)
    }
    
    
    // MARK:- RadarResponderDelegate
    func userAuthorizedRanging() {
        self.start()
    }
    
    func userRevokedRanging() {
        self.stop()
    }
    
    func rangingFailed(error: NSError) {
        self.stop()
    }
    
    func rangedBeacons(beacons: ([CLBeacon])) {
//        for beaconActivity in self.beaconActivities {
//            for beacon in beacons {
//                if beaconActivity.beaconId.major == beacon.major && beaconActivity.beaconId.minor == beacon.minor {
//                    beaconActivity.updateProximity(beacon.proximity)
//                }
//            }
//        }
    }
}


