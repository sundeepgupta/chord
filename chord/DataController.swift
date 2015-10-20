import CoreData
import CoreLocation

class DataController {
    let persistenceController: PersistenceController
    
    init(persistenceController: PersistenceController) {
        self.persistenceController = persistenceController
    }
    
    func createKid(name: String, major: CLBeaconMajorValue, minor: CLBeaconMinorValue, tracking: Bool, proximity: CLProximity) -> Kid {
        let kid = self.persistenceController.create("Kid") as! Kid
        kid.name = name
        kid.major = Int32(major)
        kid.minor = Int32(minor)
        kid.tracking = tracking
        kid.proximity = Int16(proximity.rawValue)
        
        return kid
    }
    
    func save() {
        self.persistenceController.save()
        
        // needs to throw or handle error
    }
    
    func deleteKid(kid: Kid) {
        self.persistenceController.delete(kid)
    }
    
    func kidsResultsController(delegate delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
        let sorter = NSSortDescriptor(key: "name", ascending: true)
        let resultsController = self.persistenceController.fetchedResultsController("Kid", predicate: nil, sorters: [sorter], sectionBy: "proximity", cacheName: nil)
        resultsController.delegate = delegate
        
        return resultsController
    }
}
