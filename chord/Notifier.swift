import UIKit

struct Notifier {
    static func sendNewKid(beaconId: BeaconId) {
        let note = UILocalNotification()
        note.alertBody = "New Kid Detected"
        note.userInfo = [Key.beaconId: beaconId]
        UIApplication.sharedApplication().presentLocalNotificationNow(note)
    }
}


