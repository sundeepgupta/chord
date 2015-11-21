typealias BeaconId = [String: NSObject]

extension Dictionary where Key: StringLiteralConvertible, Value: NSObject {
    var uuid: String {
        get {
            return self["uuid"] as! String
        }
    }
    
    var major: NSNumber {
        get {
            return self["major"] as! NSNumber
        }
    }
    
    var minor: NSNumber {
        get {
            return self["minor"] as! NSNumber
        }
    }
}



import CoreLocation
extension CLBeacon {
    func toBeaconId() -> BeaconId {
        return [
            DictionaryKey.uuid: self.proximityUUID.UUIDString,
            DictionaryKey.major: self.major,
            DictionaryKey.minor: self.minor
        ]
    }
}



extension SequenceType where Generator.Element == BeaconId  {
    func includes (element: Generator.Element) -> Bool {
        return self.contains { myElement -> Bool in
            return myElement == element
        }
    }
}