import CoreData
import CoreLocation

class DataController: NSObject {
    let persistenceController: PersistenceController
    
    init(persistenceController: PersistenceController) {
        self.persistenceController = persistenceController
        super.init()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateProximity:", name: NotificationName.proximityDidChange, object: nil)
    }
    
    func createKid(name: String, uuid: String, major: CLBeaconMajorValue, minor: CLBeaconMinorValue, tracking: Bool, proximity: CLProximity) -> Kid {
        let kid = self.persistenceController.create("Kid") as! Kid
        kid.name = name
        kid.uuid = uuid
        kid.major = Int32(major)
        kid.minor = Int32(minor)
        kid.tracking = tracking
        kid.proximityString = proximity.toString()
        
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
    
    
    dynamic func updateProximity(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let beaconId = userInfo[Key.beaconId] as! BeaconId
        
        let uuid = beaconId.UUID.UUIDString
        let major = beaconId.major
        let minor = beaconId.minor
        let predicate = NSPredicate(format: "uuid == %@ && major == %@ && minor == %@", uuid, major, minor)
        
        let kids = self.persistenceController.objects("Kid", predicate: predicate, sorters: nil)
        
        switch kids.count {
        case 0:
            print("No Kid found for beacon ID: \(beaconId)")
        case 1:
            let kid = kids.first as! Kid
            kid.proximityString = userInfo[Key.proximityString] as! String
        default:
            print("Error - multiple Kids found for beacon ID: \(beaconId)")
        }
    }
}
