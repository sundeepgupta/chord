import CoreLocation

enum Proximity: Equatable {
    case Pending
    case OutOfRange
    case InRange(CLProximity)
    
    func toString() -> String {
        switch self {
        case .Pending: return ProximityStrings.pending
        case .OutOfRange: return ProximityStrings.outOfRange
        case .InRange(let beaconProximity): return self.beaconProximityToString(beaconProximity)
        }
    }
    
    
    private func beaconProximityToString(proximity: CLProximity) -> String {
        switch proximity {
        case .Far: return ProximityStrings.far
        case .Immediate: return ProximityStrings.immediate
        case .Near: return ProximityStrings.near
        case .Unknown: return ProximityStrings.unknown
        }
    }
}

extension String {
    func toProximity() -> Proximity {
        switch self {
        case ProximityStrings.pending: return Proximity.Pending
        case ProximityStrings.outOfRange: return Proximity.OutOfRange
        case ProximityStrings.far: return Proximity.InRange(.Far)
        case ProximityStrings.immediate: return Proximity.InRange(.Immediate)
        case ProximityStrings.near: return Proximity.InRange(.Near)
        case ProximityStrings.unknown: return Proximity.InRange(.Unknown)
        default: fatalError("The given string cannot be converted to Proximity.")
        }
    }
}

struct ProximityStrings {
    static let pending = "Pending"
    static let outOfRange = "Out of range"
    static let far = "Far"
    static let immediate = "Immediate"
    static let near = "Near"
    static let unknown = "Unknown"
}


func ==(lhs: Proximity, rhs: Proximity) -> Bool {
    switch (lhs, rhs) {
    case (let .InRange(lhsProximity), let .InRange(rhsProximity)):
        return lhsProximity == rhsProximity
        
    case (.OutOfRange, .OutOfRange):
        return true
        
    case (.Pending, .Pending):
        return true
        
    default:
        return false
    }
}