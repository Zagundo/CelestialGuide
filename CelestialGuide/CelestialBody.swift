import Foundation

struct CelestialBody {
    let name: String
    var distanceFromEarth: Double? = nil
    var distanceFromSun: Double? = nil
    var phase: Double? = nil // For Moon's phase (as a percentage, for example)
    var riseTime: Date? = nil
    var setTime: Date? = nil
    var azimuth: Double? = nil
}
