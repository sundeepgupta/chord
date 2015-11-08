import CoreBluetooth
import CoreLocation

class Radar: NSObject, RadarResponderDelegate {
    private let locationManager: CLLocationManager
    private let region: CLBeaconRegion
    private let responder: RadarResponder
    private var activities: [BeaconActivity] = []
    private let proximityReaction: (BeaconId, Proximity) -> ()
    private let proximityDelay: NSTimeInterval = 3
    
    
    init(locationManager: CLLocationManager, region: CLBeaconRegion, responder: RadarResponder, proximityReaction: (BeaconId, Proximity) -> ()) {
        self.locationManager = locationManager
        self.region = region
        self.responder = responder
        self.proximityReaction = proximityReaction
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
        let beaconIds = self.beaconIds(beacons: beacons)
        self.handleOutOfRangeBeacons(beaconIds: beaconIds)
        self.handleInRangeBeacons(beacons, beaconIds: beaconIds)
    }
    
    
    // MARK:- Private
    private func handleInRangeBeacons(beacons: [CLBeacon], beaconIds: [BeaconId]) {
        let activityIds = self.activityIds()
        
        for i in 0..<beacons.count {
            let beacon = beacons[i]
            
            if activityIds.contains(beaconIds[i]) {
                self.activities[i].update(beacon.proximity)
            } else {
                let activity = BeaconActivity(beaconId: beacon.beaconId(), proximity: beacon.proximity, probationPeriod: self.proximityDelay, proximityReaction: self.proximityReaction)
                self.activities.append(activity)
            }
        }
    }
    
    private func handleOutOfRangeBeacons(beaconIds beaconIds: [BeaconId]) {
        for activity in self.activities {
            if !beaconIds.contains(activity.beaconId) {
                activity.update(nil)
            }
        }
    }
    
    private func activityIds() -> [BeaconId] {
        var ids: [BeaconId] = []
        for activity in self.activities {
            ids.append(activity.beaconId)
        }
        
        // Using map() here crashes with bad access.
        
        return ids
    }
    
    private func beaconIds(beacons beacons: [CLBeacon]) -> [BeaconId] {
        return beacons.map { (beacon) -> BeaconId in
            return beacon.beaconId()
        }
    }
}