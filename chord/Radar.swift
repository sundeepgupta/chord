import CoreBluetooth
import CoreLocation

class Radar: NSObject, RadarResponderDelegate {
    private let locationManager: CLLocationManager
    private let region: CLBeaconRegion
    private let responder: RadarResponder
    
    
    init(locationManager: CLLocationManager, region: CLBeaconRegion, responder: RadarResponder) {
        self.locationManager = locationManager
        self.region = region
        self.responder = responder
    }
    
    func start() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startMonitoringForRegion(self.region)
        self.locationManager.startUpdatingLocation()
    }
    
    func stop() {
        self.locationManager.stopMonitoringForRegion(self.region)
        self.locationManager.stopUpdatingLocation()
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
}


