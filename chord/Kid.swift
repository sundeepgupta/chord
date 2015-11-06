import CoreData
import CoreLocation


class Kid: NSManagedObject {
    @NSManaged var uuid: String
    @NSManaged var major: Int32
    @NSManaged var minor: Int32
    @NSManaged var name: String
    @NSManaged var tracking: Bool
    @NSManaged var proximityString: String
}
