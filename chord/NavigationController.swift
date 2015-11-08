import UIKit

class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "presentKid:", name: NotificationName.newKidWasDetected, object: nil)
    }
    
    dynamic func presentKid(notification: NSNotification) {
        let navigationController = self.storyboard!.instantiateViewControllerWithIdentifier("AddKidNavigationController") as! UINavigationController
        let addKidViewController = navigationController.viewControllers.first as! AddKidViewController
        addKidViewController.beaconId = notification.userInfo![Key.beaconId] as! BeaconId
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
}