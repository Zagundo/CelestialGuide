import Foundation
import SwiftAA

class AstronomyManager {
    
    func fetchSunData(for date: Date = Date()) -> CelestialBody {
        let julianDay = JulianDay(date)
        let sun = Sun(julianDay: julianDay)
        let moon = Moon(julianDay: julianDay)  // Create Moon to get its distance
        
        let sunDistanceFromEarth = sun.radiusVector.value    // Sun's distance from Earth in astronomical units
        let moonDistanceFromEarth = moon.radiusVector.value    // Moon's distance from Earth in asatronomical units
        
        // Approximate Sun's distance from Moon as the absolute difference:
        let sunDistanceFromMoon = abs(sunDistanceFromEarth - moonDistanceFromEarth)
        
        return CelestialBody(
            name: "Sun",
            distanceFromEarth: sunDistanceFromEarth,
            distanceFromSun: nil,  // Not applicable for the Sun
            distanceFromMoon: sunDistanceFromMoon,
            phase: nil,
            riseTime: nil,
            setTime: nil,
            azimuth: nil
        )
    }
    
    func fetchMoonData(for date: Date = Date()) -> CelestialBody {
        let julianDay = JulianDay(date)
        let moon = Moon(julianDay: julianDay)
        let sun = Sun(julianDay: julianDay)  // Create Sun to get its distance
        
        let moonDistanceFromEarth = moon.radiusVector.value    // Moon's distance from Earth
        let moonDistanceFromSun = abs(sun.radiusVector.value - moonDistanceFromEarth)
        
        // Placeholder for phase (replace with proper calculation later)
        let phasePlaceholder = 0.5
        
        return CelestialBody(
            name: "Moon",
            distanceFromEarth: moonDistanceFromEarth,
            distanceFromSun: moonDistanceFromSun,
            distanceFromMoon: nil,  // Not applicable for the Moon
            phase: phasePlaceholder,
            riseTime: nil,
            setTime: nil,
            azimuth: nil
        )
    }
    
    func fetchEarthData(for date: Date = Date()) -> CelestialBody {
        let julianDay = JulianDay(date)
        let sun = Sun(julianDay: julianDay)
        let moon = Moon(julianDay: julianDay)
        
        let earthDistanceFromSun = sun.radiusVector.value
        let earthDistanceFromMoon = moon.radiusVector.value
        
        return CelestialBody(
            name: "Earth",
            distanceFromSun: earthDistanceFromSun,
            distanceFromMoon: earthDistanceFromMoon,
            phase: nil,
            riseTime: nil,
            setTime: nil,
            azimuth: nil
        )
    }
}
