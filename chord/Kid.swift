import CoreData

class Kid: NSManagedObject {
    @NSManaged var major: Int32
    @NSManaged var minor: Int32
    @NSManaged var name: String
    @NSManaged var tracking: Bool
    @NSManaged var proximity: Int16
}
