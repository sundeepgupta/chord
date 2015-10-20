import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var dataController: DataController!
    
    var radar: Radar!
    
    

    
    //MARK:- UIApplicationDelegate
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.setupRadar()
        self.setupDataController()
        self.setupKidsViewController()
        
        
        
        self.addTestData()
        
        
        
        return true
    }
    
    func addTestData() {
        self.dataController.createKid("Neeya", major: 1, minor: 2, tracking: true, proximity: .Near)
        self.dataController.createKid("Kira", major: 828, minor: 999, tracking: false, proximity: .Far)
        self.dataController.save()
    }
    
    func applicationWillTerminate(application: UIApplication) {
        self.dataController.save()
    }
    
    
    
    
    // MARK: - Private
    private func setupRadar() {
        let uuid = "B9407F30-F5F8-466E-AFF9-25556B57FE6D"  // Estimote
//        let uuid = "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"  // Long USB April Brother
        //        let uuid = "19d5f76a-fd04-5aa3-b16e-e93277163af6"  // Short USB
        //        let uuid = "D28228BA-EB75-4CB6-8EEF-4C0C8590804A"  // White discs
        
        guard let radar = RadarFactory.radar(uuid) else {
            print("Failed to create radar.")
            return
        }

        self.radar = radar
        self.radar.start()
    }
    
    private func setupDataController() {
        let persistenceStack = PersistenceStack(modelName: "Chord")
        let persistenceController = PersistenceController(context: persistenceStack.context)
        self.dataController = DataController(persistenceController: persistenceController)
    }
    
    private func setupKidsViewController() {
        let kidsViewController = self.mainViewController() as! KidsViewController
        kidsViewController.dataController = self.dataController
    }
    
    private func mainViewController() -> UIViewController {
        let navigationController = self.window!.rootViewController as! UINavigationController
        
        return navigationController.viewControllers.first!
    }
}

