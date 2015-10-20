import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    var radar: Radar!
    
    var persistenceStack: PersistenceStack!

    
    //MARK:- UIApplicationDelegate
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.setupRadar()
        
        
        self.persistenceStack = PersistenceStack(modelName: "Chord")
        
        return true
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // save core data context
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
}

