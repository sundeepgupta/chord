import CoreBluetooth
import CoreLocation

class Radar: NSObject, RadarResponderDelegate {
    private let locationManager: CLLocationManager
    private let region: CLBeaconRegion
    private let responder: RadarResponder
    private var activities: [BeaconActivity] = []
    private let proximityReaction: (BeaconId, Proximity) -> ()
    private let shouldSkipProbation: Proximity -> Bool
    private let proximityDelay: NSTimeInterval = 3
    
    
    init(
        locationManager: CLLocationManager,
        region: CLBeaconRegion,
        responder: RadarResponder,
        proximityReaction: (BeaconId, Proximity) -> (),
        shouldSkipProbation: Proximity -> Bool
        ) {
            self.locationManager = locationManager
            self.region = region
            self.responder = responder
            self.proximityReaction = proximityReaction
            self.shouldSkipProbation = shouldSkipProbation
    }
    
    func start() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startMonitoringForRegion(self.region)
        self.locationManager.startMonitoringSignificantLocationChanges()
        self.locationManager.startUpdatingLocation()
    }
    
    func stop() {
        self.locationManager.stopMonitoringForRegion(self.region)
        self.locationManager.stopMonitoringSignificantLocationChanges()
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
    
    func rangedBeacons(beacons: ([CLBeacon])) {
        let beaconIds = self.beaconIds(beacons: beacons)
        self.handleOutOfRangeBeacons(beaconIds: beaconIds)
        self.handleInRangeBeacons(beacons, beaconIds: beaconIds)
    }
    
    
    // MARK:- Private
    private func handleOutOfRangeBeacons(beaconIds beaconIds: [BeaconId]) {
        for activity in self.activities {
            
            let inRange = beaconIds.includes(activity.beaconId)
            
            if !inRange {
                activity.update(nil)
            }
        }
    }
    
    private func handleInRangeBeacons(beacons: [CLBeacon], beaconIds: [BeaconId]) {
        let activityIds = self.activityIds()
        
        for i in 0..<beacons.count {
            let beacon = beacons[i]
            
            let alreadyTracking = activityIds.includes(beaconIds[i])
            
            if alreadyTracking {
                self.activities[i].update(beacon.proximity)
            } else {
                let activity = BeaconActivity(
                    beaconId: beacon.toBeaconId(),
                    proximity: beacon.proximity,
                    probationPeriod: self.proximityDelay,
                    proximityReaction: self.proximityReaction,
                    shouldSkipProbation: self.shouldSkipProbation
                )
                self.activities.append(activity)
            }
        }
    }
    
    private func activityIds() -> [BeaconId] {
        return self.activities.map { $0.beaconId }
    }
    
    private func beaconIds(beacons beacons: [CLBeacon]) -> [BeaconId] {
        return beacons.map { $0.toBeaconId() }
    }
}