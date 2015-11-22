import UIKit

class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func addKid(beaconId: BeaconId) {
        let navigationController = self.storyboard!.instantiateViewControllerWithIdentifier("AddKidNavigationController") as! UINavigationController
        let addKidViewController = navigationController.viewControllers.first as! AddKidViewController
        addKidViewController.beaconId = beaconId
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func showKids() {
        self.popToRootViewControllerAnimated(true)
    }
}