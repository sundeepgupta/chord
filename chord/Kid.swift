import CoreData
import CoreLocation


class Kid: NSManagedObject {
    @NSManaged var uuid: String
    @NSManaged var major: Int32
    @NSManaged var minor: Int32
    @NSManaged var name: String
    @NSManaged var tracking: Bool
    @NSManaged var proximity: Int16
    
    func proximityText() -> String {
        let proximity = CLProximity(rawValue: Int(self.proximity))!
        
        switch proximity {
        case .Far:
            return "Far"
        case .Near:
            return "Near"
        case .Immediate:
            return "Immediate"
        default:
            return "Unknown"
        }
    }
}
