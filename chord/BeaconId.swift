typealias BeaconId = [String: NSObject]


import CoreLocation
extension CLBeacon {
    func toBeaconId() -> BeaconId {
        return [Key.uuid: self.proximityUUID.UUIDString, Key.major: self.major, Key.minor: self.minor]
    }
}


extension SequenceType where Generator.Element == BeaconId  {
    func includes (element: Generator.Element) -> Bool {
        return self.contains { myElement -> Bool in
            return myElement == element
        }
    }
}