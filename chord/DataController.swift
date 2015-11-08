import CoreData
import CoreLocation

class DataController: NSObject {
    let persistenceController: PersistenceController
    
    init(persistenceController: PersistenceController) {
        self.persistenceController = persistenceController
        super.init()
        
        self.addObservers()
    }
    
    func createKid(name: String, uuid: String, major: Int32, minor: Int32, tracking: Bool, proximity: CLProximity) -> Kid {
        let kid = self.persistenceController.create("Kid") as! Kid
        kid.name = name
        kid.uuid = uuid
        kid.major = major
        kid.minor = minor
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
    
    
    // MARK:- Observers
    dynamic func updateProximity(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let beaconId = userInfo[Key.beaconId] as! BeaconId
        
        let uuid = beaconId.uuid
        let major = beaconId.major
        let minor = beaconId.minor
        let predicate = NSPredicate(format: "uuid == %@ && major == %@ && minor == %@", uuid, major, minor)
        
        let kids = self.persistenceController.objects("Kid", predicate: predicate, sorters: nil)
        
        switch kids.count {
        case 0:
            Poke.send(beaconId)
        case 1:
            let kid = kids.first as! Kid
            kid.proximityString = userInfo[Key.proximityString] as! String
        default:
            fatalError("Error - multiple Kids found for beacon ID: \(beaconId)")
        }
    }
    
    
    
    dynamic func addKid(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let beaconId = userInfo[Key.beaconId] as! BeaconId
        let major = Int32(beaconId.major as Int)
        let minor = Int32(beaconId.minor as Int)
        let uuid = beaconId.uuid
        let name = userInfo[Key.name] as! String
        let tracking = userInfo[Key.tracking] as! Bool
        
        self.createKid(name, uuid: uuid, major: major, minor: minor, tracking: tracking, proximity: .Immediate)
    }
    
    
    // MARK:- Private
    private func addObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateProximity:", name: NotificationName.proximityDidChange, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "addKid:", name: NotificationName.newKidWasAdded, object: nil)
    }
}
