import UIKit
import CoreData

class KidsViewController: UIViewController, KidUpdater, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var kidsView: UICollectionView!
    private var kidsResultsController: NSFetchedResultsController!
    var dataController: DataController!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Kids"
        self.setupKidsResultsController()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UICollectionViewCell
        let indexPath = self.kidsView .indexPathForCell(cell)!
        let kidViewController = segue.destinationViewController as! KidViewController
        
        kidViewController.kid = self.kidsResultsController.objectAtIndexPath(indexPath) as! Kid
        kidViewController.delegate = self
    }

    
    //MARK:- UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        guard let sections = self.kidsResultsController.sections else { return 1 }
        
        return sections.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let objects = self.kidsResultsController.fetchedObjects else { return 0 }
        guard let sections = self.kidsResultsController.sections else { return objects.count }
        
        return sections[section].numberOfObjects
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identifier = KidCell.identifier()
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! KidCell
        
        let kid = self.kidsResultsController.objectAtIndexPath(indexPath) as! Kid
        cell.configure(kid: kid)
        
        return cell
    }
    
    
    //MARK:- KidUpdater
    func didUpdateKid(kid: Kid) {
        self.dataController.save()
    }
    
    func didDeleteKid(kid: Kid) {
        self.dataController.deleteKid(kid)
    }
    
    
    //MARK:- NSFetchedResultsControllerDelegate
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.kidsView.reloadData()
    }
    
    
    //MARK:- Private
    private func setupKidsResultsController() {
        self.kidsResultsController = self.dataController.kidsResultsController(delegate: self)
        
        do {
            try self.kidsResultsController.performFetch()
        } catch let error as NSError {
            print("Failed to fetch kids with error: \(error.localizedDescription)")
        }        
    }
}

