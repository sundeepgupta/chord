import CoreData
import CoreLocation

class DataController: NSObject {
    let persistenceController: PersistenceController
    
    init(persistenceController: PersistenceController) {
        self.persistenceController = persistenceController
        super.init()
        
        self.addObservers()
    }
    
    func createKid(name name: String, beaconId: BeaconId, tracking: Bool, proximityString: String) -> Kid {
        let kid = self.persistenceController.create("Kid") as! Kid
        kid.name = name
        kid.uuid = beaconId.uuid
        kid.major = Int32(beaconId.major as Int)
        kid.minor = Int32(beaconId.minor as Int)
        kid.tracking = tracking
        kid.proximityString = proximityString
        
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
        let resultsController = self.persistenceController.fetchedResultsController("Kid", predicate: nil, sorters: [sorter], sectionBy: "proximityString", cacheName: nil)
        resultsController.delegate = delegate
        
        return resultsController
    }
    
    
    // MARK:- Observers
    dynamic func updateProximity(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let proximityString = userInfo[DictionaryKey.proximityString] as! String
        let beaconId = userInfo[DictionaryKey.beaconId] as! BeaconId
        let kids = self.kidsForBeaconId(beaconId)
        
        switch kids.count {
        case 0:
            self.handleNewBeaconId(beaconId, proximityString: proximityString)
        case 1:
            let kid = kids.first!
            kid.proximityString = proximityString
        default:
            fatalError("Error - multiple Kids found for beacon ID: \(beaconId)")
        }
    }
    
    
    
    dynamic func addKid(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let beaconId = userInfo[DictionaryKey.beaconId] as! BeaconId
        let name = userInfo[DictionaryKey.name] as! String
        let tracking = userInfo[DictionaryKey.tracking] as! Bool
        
        self.createKid(name: name, beaconId: beaconId, tracking: tracking, proximityString: ProximityStrings.pending)
    }
    

    
    
    // MARK:- Private
    private func addObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateProximity:", name: NotificationName.proximityDidChange, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "addKid:", name: NotificationName.newKidWasAdded, object: nil)
    }
    
    private func kidsForBeaconId(beaconId: BeaconId) -> [Kid] {
        let predicate = NSPredicate(format: "uuid == %@ && major == %@ && minor == %@", beaconId.uuid, beaconId.major, beaconId.minor)
        return self.persistenceController.objects("Kid", predicate: predicate, sorters: nil) as! [Kid]
    }
    
    private func handleNewBeaconId(beaconId: BeaconId, proximityString: String) {
        if proximityString == ProximityStrings.immediate {
            Notifier.sendNewKid(beaconId)
        }
    }
}
