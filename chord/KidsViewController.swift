import UIKit

class KidsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var kidsView: UICollectionView!
    var kids: [Kid]!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let kid = Kid(major: 1, minor: 2, name: "test", tracking: true)
        let kid1 = Kid(major: 333, minor: 33, name: "kid1", tracking: false)
        self.kids = [kid, kid1]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UICollectionViewCell
        guard let indexPath = self.kidsView .indexPathForCell(cell) else { return }
        
        let kidViewController = segue.destinationViewController as! KidViewController
        kidViewController.kid = self.kids[indexPath.item]
    }

    
    //MARK:- UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.kids.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identifier = KidCell.identifier()
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! KidCell
        
        let kid = self.kids[indexPath.item]
        
        cell.configure(kid: kid)
        
        return cell
    }
    
    

}

