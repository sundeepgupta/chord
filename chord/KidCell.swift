import UIKit

class KidCell: UICollectionViewCell {
    @IBOutlet private weak var name: UILabel!
    @IBOutlet weak var proximity: UILabel!
    
    static func identifier() -> String {
        return "KidCell"
    }
    
    func configure(kid kid: Kid) {
        self.name.text = kid.name
        self.proximity.text = kid.proximityString
        
        print(kid.proximityString)
        
        self.alpha = kid.tracking ? 1 : 0.3 as CGFloat
    }
}
