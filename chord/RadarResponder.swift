import CoreBluetooth
import CoreLocation

protocol RadarResponderDelegate: class {
    func userAuthorizedRanging()
    func userRevokedRanging()
    func rangingFailed(error: NSError)
    func rangedBeacons(beacons: ([CLBeacon]))
}

class RadarResponder: NSObject, CLLocationManagerDelegate {
    weak var delegate: RadarResponderDelegate!
        
    // MARK: - CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        manager.requestStateForRegion(region)
        print("Started monitoring.")
    }
    
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        if state == .Inside {
            manager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
            print("Determined inside the region.")
        } else {
            manager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
            print("Determined outside the region.")
        }
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        manager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
        print("Entered the region.")
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        self.delegate.rangedBeacons(beacons)
        print("Ranged beacons: \(beacons)")
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        manager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
        print("Exited the region.")
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways {
            self.delegate.userAuthorizedRanging()
            print("User authorized ranging.")
        } else {
            self.delegate.userRevokedRanging()
            print("User denied ranging.")
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        self.delegate.rangingFailed(error)
        print("Location manager failed with error: \(error.localizedDescription)")
    }
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        self.delegate.rangingFailed(error)
        print("Location manager failed monitoring with error: \(error.localizedDescription)")
    }
    
    func locationManager(manager: CLLocationManager, rangingBeaconsDidFailForRegion region: CLBeaconRegion, withError error: NSError) {
        self.delegate.rangingFailed(error)
        print("Location manager ranging failed with error: \(error.localizedDescription)")
    }
}