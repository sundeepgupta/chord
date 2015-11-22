import UIKit

struct UserNotifier {
    static func requestNotificationPermissions(application application: UIApplication) {
        let types:UIUserNotificationType = [.Sound, .Alert]
        let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
        application.registerUserNotificationSettings(settings)
    }
    
    static func newKid(beaconId: BeaconId) {
        self.sendNotification("New Kid Detected", userInfo: [DictionaryKey.beaconId: beaconId])
    }
    
    static func findKid(kid: Kid) {
        self.sendNotification("Find \(kid.name)!", userInfo: nil)
    }
    
    private static func sendNotification(body: String, userInfo: [NSObject: AnyObject]?) {
        let notification = UILocalNotification()
        notification.alertBody = body
        notification.userInfo = userInfo
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }
}


