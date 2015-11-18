import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var dataController: DataController!
    var radar: Radar!
    var navigationController: NavigationController!

    
    //MARK:- UIApplicationDelegate
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.setupNavigationController()
        self.setupRadar()
        self.setupDataController()
        self.setupKidsViewController()
        
        return true
    }
    
    func applicationWillTerminate(application: UIApplication) {
        self.dataController.save()
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        let beaconId = notification.userInfo![DictionaryKey.beaconId] as! [String: NSObject]
        // Will need to check here or eventually have a NotifcationTriage object
        
        self.navigationController.addKid(beaconId)
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
    
    private func setupNavigationController() {
        self.navigationController = self.window!.rootViewController as! NavigationController
    }
    
    private func mainViewController() -> UIViewController {
        return self.navigationController.viewControllers.first!
    }
}

