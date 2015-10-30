import XCTest
@testable import chord


class KidCell_Tests: XCTestCase {
    var subject: KidCell!
    var kidsViewController: KidsViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.kidsViewController = storyboard.instantiateViewControllerWithIdentifier("KidsViewController") as! KidsViewController
    }
    
//    func subject(kid: Kid) -> KidCell {
//        self.kidsViewController.kids = [kid]
//        self.kidsViewController.loadView()
//        
//        let indexPath = NSIndexPath(forItem: 0, inSection: 0)
//        let cell = kidsViewController.collectionView(kidsViewController.kidsView, cellForItemAtIndexPath: indexPath) as! KidCell
//        
//        return cell
//    }
//    
//    func testOpacityWhenTrackingKid() {
//        let kid = Kid(major: 0, minor: 0, name: "", tracking: true)
//        let subject = self.subject(kid)
//        
//        subject.configure(kid: kid)
//        
//        XCTAssertEqual(subject.alpha, 1)
//    }
//    
//    func testOpacityWhenNotTrackingKid() {
//        let kid = Kid(major: 0, minor: 0, name: "", tracking: false)
//        let subject = self.subject(kid)
//        
//        subject.configure(kid: kid)
//        
//        XCTAssertNotEqual(subject.alpha, 1)
//    }
    
}
