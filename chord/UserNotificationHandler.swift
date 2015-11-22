import UIKit

struct UserNotificationHandler {
    let navigationController: NavigationController
    
    init(navigationController: NavigationController) {
        self.navigationController = navigationController
        
    }
    
    func handleNotification(notification: UILocalNotification) {
        let userInfo = notification.userInfo!
        
        let rawType = userInfo[DictionaryKey.userNotificationType] as! UserNotificationType.RawValue
        let type = UserNotificationType(rawValue: rawType)!
        
        switch type {
        case .NewKid:
            let beaconId = userInfo[DictionaryKey.beaconId] as! [String: NSObject]
            self.navigationController.addKid(beaconId)

        case .FindKid:
            self.navigationController.showKids()
        }
    }
}
