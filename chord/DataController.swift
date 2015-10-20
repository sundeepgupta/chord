import CoreData
import CoreLocation

class DataController {
    let persistenceController: PersistenceController
    
    init(persistenceController: PersistenceController) {
        self.persistenceController = persistenceController
    }
    
    func create(name: String, major: CLBeaconMajorValue, minor: CLBeaconMinorValue, tracking: Bool, proximity: CLProximity) -> Kid {
        
    }
    
    func fetchedResultsController() -> NSFetchedResultsController {
        
        
        
    }
    
}
