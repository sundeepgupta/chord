import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var dataController: DataController!
    private var radar: Radar!
    private var navigationController: NavigationController!
    private var proximityObserver: ProximityObserver!
    private var userNotificationHandler: UserNotificationHandler!

    
    //MARK:- UIApplicationDelegate
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.setupNavigationController()
        self.setupRadar()
        self.setupDataController()
        self.setupKidsViewController()
        self.setupProximityObserver()
        self.setupUserNotificationHandler()
        
        UserNotifier.requestNotificationPermissions(application: application)
        
        if let notification = launchOptions?[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification {
            self.userNotificationHandler.handleNotification(notification)
        }
        
        return true
    }
    
    func applicationWillTerminate(application: UIApplication) {
        self.dataController.save()
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        self.userNotificationHandler.handleNotification(notification)
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
    
    private func setupProximityObserver() {
        self.proximityObserver = ProximityObserver(dataController: self.dataController)
    }
    
    private func setupUserNotificationHandler() {
        self.userNotificationHandler = UserNotificationHandler(navigationController: self.navigationController)
    }
    
    private func mainViewController() -> UIViewController {
        return self.navigationController.viewControllers.first!
    }
}

