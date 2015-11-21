import UIKit

struct Notifier {
    static func sendNewKid(beaconId: BeaconId) {
        let notification = UILocalNotification()
        notification.alertBody = "New Kid Detected"
        notification.userInfo = [DictionaryKey.beaconId: beaconId]
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }
}


