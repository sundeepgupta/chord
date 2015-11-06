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
        
//        self.addTestData()
        
        return true
    }
    
    func addTestData() {
        self.dataController.createKid("Neeya", uuid: Global.uuid, major: 2178, minor: 3672, tracking: true, proximity: .Near)
//        self.dataController.createKid("Kira", major: 828, minor: 999, tracking: false, proximity: .Far)
        self.dataController.save()
    }
    
    func applicationWillTerminate(application: UIApplication) {
        self.dataController.save()
    }
    
    
    
    
    // MARK: - Private
    private func setupRadar() {
        guard let radar = RadarFactory.radar(Global.uuid) else {
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

