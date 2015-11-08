import UIKit

class AddKidViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var trackingSetting: UISwitch!
    var beaconId: BeaconId!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Kid"
        self.name.becomeFirstResponder()
    }
    
    @IBAction func save() {
        // Need to add validation
        
        
        let userInfo: [String: AnyObject] = [
            Key.beaconId: self.beaconId,
            Key.name: self.name.text!,
            Key.tracking: self.trackingSetting.on
        ]
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.newKidWasAdded, object: nil, userInfo: userInfo)
        self.dismiss()
    }
    
    @IBAction func cancel() {
        self.dismiss()
    }
    
    
    // MARK:- UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.save()
        
        return true
    }
    
    
    // MARK:- Private
    private func dismiss() {
        self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
}