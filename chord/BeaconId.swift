import CoreLocation


class BeaconId: Equatable {
    let UUID: NSUUID
    let major: NSNumber
    let minor: NSNumber
    
    init(UUID: NSUUID, major: NSNumber, minor: NSNumber) {
        self.UUID = UUID
        self.major = major
        self.minor = minor
    }
}


// MARK:- Equatable
func ==(lhs: BeaconId, rhs: BeaconId) -> Bool {
    return lhs.UUID == rhs.UUID && lhs.major == rhs.major && lhs.minor == rhs.minor
}



extension CLBeacon {
    func beaconId() -> BeaconId {
        return BeaconId(UUID: self.proximityUUID, major: self.major, minor: self.minor)
    }
}