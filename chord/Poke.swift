import UIKit

struct Poke {
    static func send(beaconId: BeaconId) {
        let poke = UILocalNotification()
        poke.alertBody = "New Chord Detected"
        poke.userInfo = [Key.beaconId: beaconId]
        UIApplication.sharedApplication().presentLocalNotificationNow(poke)
    }
}
