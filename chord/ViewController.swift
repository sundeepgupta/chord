import UIKit

class ViewController: UIViewController {
    var ranger = Ranger()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ranger.start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

