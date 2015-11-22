import UIKit

struct UserNotificationHandler {
    let navigationController: NavigationController
    
    init(navigationController: NavigationController) {
        self.navigationController = navigationController
        
    }
    
    func handleNotification(notification: UILocalNotification) {
        let beaconId = notification.userInfo![DictionaryKey.beaconId] as! [String: NSObject]
        self.navigationController.addKid(beaconId)
    }
}
