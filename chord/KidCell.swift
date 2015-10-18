import UIKit

class KidCell: UICollectionViewCell {
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var major: UILabel!
    @IBOutlet private weak var minor: UILabel!
    
    static func identifier() -> String {
        return "KidCell"
    }
    
    func configure(kid kid: Kid) {
        self.name.text = kid.name
        self.major.text = "\(kid.major)"
        self.minor.text = "\(kid.minor)"
        
        self.alpha = kid.tracking ? 1 : 0.3 as CGFloat
    }
}
