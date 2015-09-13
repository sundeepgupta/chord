import CoreBluetooth
import CoreLocation

class Ranger: NSObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var region: CLBeaconRegion!
    
    override init() {
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        
//        let uuid = "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6" // Laptop
//        let uuid = "74268846-BF00-AAFC-75B4-2ECD169F8050" // White beacon device UUID
//        let uuid = "D28228BA-EB75-4CB6-8EEF-4C0C8590804A" // White beacon broadcast UUID
        let uuid = "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0" // iPhone 5
        self.region = self.regionWithUuid(uuid)
    }
    
    func start() {
        self.locationManager.startMonitoringForRegion(self.region)
        self.locationManager.startUpdatingLocation()
    }
    
    func stop() {
        self.locationManager.stopMonitoringForRegion(self.region)
        self.locationManager.stopUpdatingLocation()
    }
    
    
    
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        self.locationManager.requestStateForRegion(self.region)
        print("Started monitoring.")
    }
    
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        if state == .Inside {
            self.locationManager.startRangingBeaconsInRegion(self.region)
            print("Determined inside the region.")
        } else {
            self.locationManager .stopRangingBeaconsInRegion(self.region)
            print("Determined outside the region.")
        }
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        self.locationManager.startRangingBeaconsInRegion(self.region)
        print("Entered the region.")
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        print("Ranged beacons: \(beacons)")
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        self.locationManager.stopRangingBeaconsInRegion(self.region)
        print("Exited the region.")
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways {
            self.start()
            print("User authorized ranging.")
        } else {
            self.stop()
            print("User denied ranging.")
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
            self.stop()
            print("Location manager failed with error: \(error.localizedDescription)")
    }
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print("Location manager failed monitoring with error: \(error.localizedDescription)")
    }
    
    func locationManager(manager: CLLocationManager, rangingBeaconsDidFailForRegion region: CLBeaconRegion, withError error: NSError) {
        print("Location manager ranging failed with error: \(error.localizedDescription)")
    }
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Private
    private func regionWithUuid(uuid: String) -> CLBeaconRegion {
        guard let UUID = NSUUID(UUIDString: uuid) else { fatalError() }
        let region = CLBeaconRegion(proximityUUID: UUID, identifier: "Aphone")
        region.notifyEntryStateOnDisplay = true
        return region
    }
}


