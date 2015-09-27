import CoreBluetooth
import CoreLocation


struct RadarFactory {
    static func radar(uuid: String) -> Radar {
        let region = self.regionWithUuid(uuid)
        let locationManager = CLLocationManager()
        let responder = RadarResponder()
        let radar = Radar(locationManager: locationManager, region: region, responder: responder)
        
        locationManager.delegate = responder
        responder.delegate = radar
        
        return radar
    }
    
    
    // MARK: - Private
    private static func regionWithUuid(uuid: String) -> CLBeaconRegion {
        guard let UUID = NSUUID(UUIDString: uuid) else { fatalError("Invalid UUID") }
        
        let region = CLBeaconRegion(proximityUUID: UUID, identifier: "Chord App")
        region.notifyEntryStateOnDisplay = true
        return region
    }
}
