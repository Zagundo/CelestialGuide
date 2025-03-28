import Foundation

struct CelestialBody {
    let name: String
    var distanceFromEarth: Double?
    var distanceFromSun: Double?
    var distanceFromMoon: Double?
    var phase: Double?
    var phaseDescription: String?
    var currentPhase: String?
    var riseTime: Date?
    var setTime: Date?
    var azimuth: Double?
    // Optionally, include:
    var perihelion: Double?
    var aphelion: Double?
    var perigee: Double?
    var apogee: Double?
    var axialTilt: Double?
}
