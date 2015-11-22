import Foundation

class ProximityObserver: NSObject {
    let dataController: DataController
    let warningProximities = [ProximityStrings.outOfRange, ProximityStrings.unknown]
    
    init(dataController: DataController) {
        self.dataController = dataController
        super.init()
        
        self.addObservers()
    }
    
    dynamic func updateProximity(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let proximityString = userInfo[DictionaryKey.proximityString] as! String
        let beaconId = userInfo[DictionaryKey.beaconId] as! BeaconId
        let kids = self.kidsForBeaconId(beaconId)
        
        switch kids.count {
        case 0:
            self.handleNewBeaconId(beaconId, proximityString: proximityString)
        case 1:
            self.updateKid(kids.first!, proximityString: proximityString)
        default:
            fatalError("Error - multiple Kids found for beacon ID: \(beaconId)")
        }
    }
    
    // MARK:- Private
    private func addObservers() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "updateProximity:",
            name: NotificationName.proximityDidChange,
            object: nil
        )
    }
    
    private func kidsForBeaconId(beaconId: BeaconId) -> [Kid] {
        let predicate = NSPredicate(
            format: "uuid == %@ && major == %@ && minor == %@",
            beaconId.uuid, beaconId.major, beaconId.minor
        )
        
        return self.dataController.kids(predicate)
    }
    
    private func handleNewBeaconId(beaconId: BeaconId, proximityString: String) {
        if proximityString == ProximityStrings.immediate {
            UserNotifier.newKid(beaconId)
        }
    }
    
    private func updateKid(kid: Kid, proximityString: String) {
        kid.proximityString = proximityString
        
        if self.warningProximities.contains(proximityString) {
            UserNotifier.findKid(kid)
        }
    }
}