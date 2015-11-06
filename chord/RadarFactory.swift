import CoreBluetooth
import CoreLocation


struct RadarFactory {
    static func radar(uuid: String) -> Radar? {
        guard let region = self.regionWithUuid(uuid) else { return nil }
        
        let locationManager = CLLocationManager()
        let responder = RadarResponder()
        let proximityReaction = { (beaconId: BeaconId, proximity: Proximity) in
            let userInfo: [String: AnyObject] = ["beaconId": beaconId, "proximityString": proximity.toString()]
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.proximityDidChange, object: nil, userInfo: userInfo)
        }
        let radar = Radar(locationManager: locationManager, region: region, responder: responder, proximityReaction: proximityReaction)
        
        locationManager.delegate = responder
        responder.delegate = radar
        
        return radar
    }
    
    
    // MARK: - Private
    private static func regionWithUuid(uuid: String) -> CLBeaconRegion? {
        guard let UUID = NSUUID(UUIDString: uuid) else { return nil }
        
        let region = CLBeaconRegion(proximityUUID: UUID, identifier: "Chord App")
        region.notifyEntryStateOnDisplay = true
        return region
    }
}
