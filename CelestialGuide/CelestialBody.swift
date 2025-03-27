
import Foundation

struct CelestialBody {
    let name: String
    var distanceFromEarth: Double?      // e.g. for Sun or Moon, the distance from Earth in kilometers
    var distanceFromSun: Double?        // e.g. for Earth or Moon, the distance from the Sun in kilometers
    var distanceFromMoon: Double?       // e.g. for Sun or Earth, the distance from the Moon in kilometers
    var phase: Double?                  // for the Moon (percentage of illumination, for example)
    var riseTime: Date?
    var setTime: Date?
    var azimuth: Double?
}
