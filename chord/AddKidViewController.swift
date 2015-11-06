import UIKit

class AddKidViewController: UIViewController {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var trackingSetting: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Kid"
    }
    
}