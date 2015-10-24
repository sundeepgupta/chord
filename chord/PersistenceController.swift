import CoreData

class PersistenceController {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func create(type: String) -> NSManagedObject {
        return NSEntityDescription.insertNewObjectForEntityForName(type, inManagedObjectContext:context)
    }
    
    func objects(type: String, predicate: NSPredicate?, sorters: [NSSortDescriptor]?) -> [AnyObject] {
        let fetchRequest = NSFetchRequest(entityName: type)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sorters
        
        do {
            return try self.context.executeFetchRequest(fetchRequest)
        } catch let error as NSError {
            fatalError("Failed to fetch objects from persistent store with error: \(error.localizedDescription)")
        }
    }
    
    func save() {
        do {
            try self.context.save()
        } catch let error as NSError {
            fatalError("Failed to save context with error: \(error.localizedDescription)")
        }
    }
    
    func delete(object: NSManagedObject) {
        self.context.deleteObject(object)
    }
    
    func fetchedResultsController(type: String, predicate: NSPredicate?, sorters: [NSSortDescriptor]?, sectionBy: String?, cacheName: String?) -> NSFetchedResultsController {
        let fetchRequest = NSFetchRequest(entityName: type)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sorters
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: sectionBy, cacheName: cacheName)
    }
}
