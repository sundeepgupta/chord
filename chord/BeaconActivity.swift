import CoreLocation

class BeaconActivity: NSObject {
    private(set) var beaconId: BeaconId
    private var timer = NSTimer()
    private let probationPeriod: NSTimeInterval
    private let reaction: (BeaconId, Proximity) -> ()
    private(set) var proximity = Proximity.Pending {
        didSet {
            self.reaction(self.beaconId, self.proximity)
        }
    }
    private var candidate: Proximity! {
        didSet {
            guard oldValue != self.candidate else { return }
            
            if self.candidate == self.proximity {
                self.timer.invalidate()
            } else {
                self.startTimer(self.candidate)
            }
        }
    }

    
    init(beaconId: BeaconId, proximity: CLProximity, probationPeriod: NSTimeInterval, proximityReaction: (BeaconId, Proximity) -> ()) {
        self.beaconId = beaconId
        self.reaction = proximityReaction
        self.candidate = .InRange(proximity)
        self.probationPeriod = probationPeriod
        super.init()
        
        self.startTimer(self.candidate) // Property observers not called during init.
    }
    
    func update(beaconProximity: CLProximity?) {
        if let p = beaconProximity {
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
    
    dynamic func acceptCandidate(timer: NSTimer) {
        let proximityString = timer.userInfo as! String
        self.proximity = proximityString.toProximity()
    }
}
