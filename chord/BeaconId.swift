import CoreLocation


class BeaconId: NSObject {
    let uuid: String
    let major: NSNumber
    let minor: NSNumber
    
    init(uuid: String, major: NSNumber, minor: NSNumber) {
        self.uuid = uuid
        self.major = major
        self.minor = minor
        
        super.init()
    }
}


// MARK:- Equatable
func ==(lhs: BeaconId, rhs: BeaconId) -> Bool {
    return lhs.uuid == rhs.uuid && lhs.major == rhs.major && lhs.minor == rhs.minor
}



extension CLBeacon {
    func beaconId() -> BeaconId {
        return BeaconId(uuid: self.proximityUUID.UUIDString, major: self.major, minor: self.minor)
    }
}