import Foundation

struct Kid {
    var major: Int
    var minor: Int
    var name: String
    var tracking: Bool
    
    init(major: Int, minor: Int, name: String, tracking: Bool) {
        self.major = major
        self.minor = minor
        self.name = name
        self.tracking = tracking
    }
}

