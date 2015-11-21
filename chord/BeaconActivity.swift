import CoreLocation

class BeaconActivity: NSObject {
    private(set) var beaconId: BeaconId
    private var timer = NSTimer()
    private let probationPeriod: NSTimeInterval
    private let reaction: (BeaconId, Proximity) -> ()
    private let shouldSkipProbation: Proximity -> Bool
    private(set) var proximity = Proximity.Pending {
        didSet {
            self.reaction(self.beaconId, self.proximity)
        }
    }
    private var candidate: Proximity! {
        didSet {
            guard oldValue != self.candidate else { return }
            
            self.candidate == self.proximity ? self.timer.invalidate() : self.processDifferentCandidate()
        }
    }

    
    init(beaconId: BeaconId, proximity: CLProximity, probationPeriod: NSTimeInterval, proximityReaction: (BeaconId, Proximity) -> (), shouldSkipProbation: Proximity -> Bool) {
        self.beaconId = beaconId
        self.reaction = proximityReaction
        self.candidate = .InRange(proximity)
        self.probationPeriod = probationPeriod
        self.shouldSkipProbation = shouldSkipProbation
        super.init()
        
        self.acceptCandidate()
    }
    
    func update(beaconProximity: CLProximity?) {
        if let p = beaconProximity {
            self.candidate = .InRange(p)
        } else {
            self.candidate = .OutOfRange
        }
    }
    
    
    // MARK:- Private
    private func startTimer() {
        self.timer.invalidate()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(self.probationPeriod, target: self, selector: "acceptCandidate", userInfo: nil, repeats: false)
    }
    
    dynamic func acceptCandidate() {
        self.proximity = self.candidate
    }
    
    private func processDifferentCandidate() {
        self.shouldSkipProbation(self.candidate) ? self.acceptCandidate() : self.startTimer()
    }
}
