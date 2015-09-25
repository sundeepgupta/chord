import UIKit
import CoreBluetooth
import CoreLocation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var radar: Radar!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.setupRadar()
        
        return true
    }
    
    
    // MARK: - Private
    private func setupRadar() {
        let uuid = "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"  // Long USB April Brother
        //        let uuid = "19d5f76a-fd04-5aa3-b16e-e93277163af6"  // Short USB
        //        let uuid = "D28228BA-EB75-4CB6-8EEF-4C0C8590804A"  // White discs
        let region = self.regionWithUuid(uuid)
        
        let locationManager = CLLocationManager()
        
        self.radar = Radar(locationManager: locationManager, region: region, responder: RadarResponder())
        self.radar.start()
    }
    
    private func regionWithUuid(uuid: String) -> CLBeaconRegion {
        guard let UUID = NSUUID(UUIDString: uuid) else { fatalError("Invalid UUID") }
        
        let region = CLBeaconRegion(proximityUUID: UUID, identifier: "Chord App")
        region.notifyEntryStateOnDisplay = true
        return region
    }
}

