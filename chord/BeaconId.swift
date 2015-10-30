import Foundation

struct BeaconId: Equatable {
    let major: NSNumber
    let minor: NSNumber
    
    init(major: NSNumber, minor: NSNumber) {
        self.major = major
        self.minor = minor
    }
}


// MARK:- Equatable
func ==(lhs: BeaconId, rhs: BeaconId) -> Bool {
    return lhs.major == rhs.major && lhs.minor == rhs.minor
}