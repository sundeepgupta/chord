import UIKit
import CoreData

class KidsViewController: UIViewController {
    @IBOutlet weak var kidsView: UICollectionView!
    var kidsResultsController: NSFetchedResultsController!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Kids"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UICollectionViewCell
        guard let indexPath = self.kidsView .indexPathForCell(cell) else { return }
        
        let kidViewController = segue.destinationViewController as! KidViewController
        
        
        
//        kidViewController.kid = self.kids[indexPath.item]
    }

    
    //MARK:- UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let kids = self.kidsResultsController.fetchedObjects else { return 0 }
        // is this correct for frc ?
        
        return kids.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identifier = KidCell.identifier()
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! KidCell
        
//        let kid = self.kids[indexPath.item]
//        
//        cell.configure(kid: kid)
        
        return cell
    }
}

