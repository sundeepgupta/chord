import UIKit

protocol KidUpdater: class {
    func didUpdateKid(kid: Kid)
    func didDeleteKid(kid: Kid)
}

class KidViewController: UIViewController {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var trackingSetting: UISwitch!
    var kid: Kid!
    weak var delegate: KidUpdater!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.kid.name
        self.name.text = self.kid.name
        self.trackingSetting.on = self.kid.tracking
    }
    
    @IBAction func delete() {
        self.delegate.didDeleteKid(self.kid)
    }
}