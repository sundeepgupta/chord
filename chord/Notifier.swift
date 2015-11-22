import UIKit

struct UserNotifier {
    static func requestPermissions(application application: UIApplication) {
        let types:UIUserNotificationType = [.Sound, .Alert]
        let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
        application.registerUserNotificationSettings(settings)
    }
    
    static func newKid(beaconId: BeaconId) {
        let userInfo: [NSObject: AnyObject] = [
            DictionaryKey.beaconId: beaconId,
            DictionaryKey.userNotificationType: UserNotificationType.NewKid.rawValue
        ]
        
        self.sendNotification("New Kid Detected", userInfo: userInfo)
    }
    
    static func findKid(kid: Kid) {
        let userInfo: [NSObject: AnyObject] = [
            DictionaryKey.userNotificationType: UserNotificationType.FindKid.rawValue
        ]
        
        self.sendNotification("Find \(kid.name)!", userInfo: userInfo)
    }
    
    private static func sendNotification(body: String, userInfo: [NSObject: AnyObject]?) {
        let notification = UILocalNotification()
        notification.alertBody = body
        notification.userInfo = userInfo
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }
}


enum UserNotificationType: Int {
    case NewKid
    case FindKid
}