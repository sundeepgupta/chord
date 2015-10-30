import CoreLocation

class BeaconActivity {
    let beaconId: BeaconId
    private var timer = NSTimer()
    let probationPeriod: NSTimeInterval = 3
    let reaction: BeaconActivity -> ()
    private(set) var proximity = Proximity.Pending {
        didSet {
            self.reaction(self)
//            NSNotificationCenter.defaultCenter().postNotificationName("BeaconProximityDidChange", object: self, userInfo: nil)
        }
    }
    private var candidate: Proximity! {
        willSet {
            guard newValue != self.candidate else { return }
            
            if newValue == self.proximity {
                self.timer.invalidate()
            }
        }
        didSet {
            self.startTimer(self.candidate)
        }
    }
    
    
    init(beaconId: BeaconId, proximity: CLProximity, proximityReaction: BeaconActivity -> ()) {
        self.beaconId = beaconId
        self.reaction = proximityReaction
        self.candidate = .InRange(proximity)
        self.startTimer(self.candidate)
    }
    
    func update(proximity: CLProximity?) {
        if let p = proximity {
            self.candidate = .InRange(p)
        } else {
            self.candidate = .OutOfRange
        }
    }
    
    
    // MARK:- Private
    private func startTimer(proximity: Proximity) {
        self.timer.invalidate()
        
        let userInfo = proximity.toString()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(self.probationPeriod, target: self, selector: "acceptCandidate:", userInfo: userInfo, repeats: false)
    }
    
    private func acceptCandidate(timer: NSTimer) {
        let proximityString = timer.userInfo as! String
        self.proximity = proximityString.toProximity()
    }
}
