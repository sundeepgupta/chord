import UIKit

class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "presentAddKid:", name: NotificationName.newKidWasDetected, object: nil)
    }
    
    dynamic func presentKid(notification: NSNotification) {
        let addKidNavigationController = self.storyboard!.instantiateViewControllerWithIdentifier("AddKidNavigationController")
        self.presentViewController(addKidNavigationController, animated: true, completion: nil)
    }
}