
import Foundation

struct CelestialBody {
    let name: String
    var distanceFromEarth: Double?      // in kilometers
    var distanceFromSun: Double?        // in kilometers
    var distanceFromMoon: Double?       // in kilometers
    var phase: Double?                  // if you later want to store a phase percentage
    var phaseDescription: String?       // for example, the next full moon date
    var currentPhase: String?           // for current moon phase (e.g., Waxing Crescent)
    var riseTime: Date?
    var setTime: Date?
    var azimuth: Double?
}
