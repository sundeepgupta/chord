import Foundation


class BeaconId: NSObject, NSCoding {
    let uuid: String
    let major: NSNumber
    let minor: NSNumber
    
    init(uuid: String, major: NSNumber, minor: NSNumber) {
        self.uuid = uuid
        self.major = major
        self.minor = minor
        
        super.init()
    }
    
    
    // MARK:- NSCoding
    required convenience init?(coder decoder: NSCoder) {
        let uuid = decoder.decodeObjectForKey(Key.uuid) as! String
        let major = decoder.decodeObjectForKey(Key.major) as! NSNumber
        let minor = decoder.decodeObjectForKey(Key.minor) as! NSNumber
        
        self.init(uuid: uuid, major: major, minor: minor)
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.uuid, forKey: Key.uuid)
        coder.encodeObject(self.major, forKey: Key.major)
        coder.encodeObject(self.minor, forKey: Key.minor)
    }
    
    
    // MARK:- NSObject
    override func isEqual(object: AnyObject?) -> Bool {
        guard let rhs = object as? BeaconId else { return false }
        
        return self.uuid == rhs.uuid && self.major == rhs.major && self.minor == rhs.minor
    }
    
    override var hash: Int {
        return self.uuid.hashValue
    }
}


import CoreLocation
extension CLBeacon {
    func beaconId() -> BeaconId {
        return BeaconId(uuid: self.proximityUUID.UUIDString, major: self.major, minor: self.minor)
    }
}