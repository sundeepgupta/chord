import CoreLocation

class BeaconActivity {
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

    
    init(beaconId: BeaconId, proximity: CLProximity, probationPeriod: NSTimeInterval, proximityReaction: (BeaconId, Proximity) -> ()) {
        self.beaconId = beaconId
        self.reaction = proximityReaction
        self.candidate = .InRange(proximity)
        self.probationPeriod = probationPeriod
        
        self.startTimer(self.candidate) // Property observers not called during init.
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
