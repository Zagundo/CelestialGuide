import Foundation
import SwiftAA

class AstronomyManager {
    
    func fetchSunData(for date: Date = Date()) -> CelestialBody {
        let julianDay = JulianDay(date)
        let sun = Sun(julianDay: julianDay)
        let moon = Moon(julianDay: julianDay)
        
        let sunDistanceFromEarth = sun.radiusVector.value    // Using radiusVector for distance
        let moonDistanceFromEarth = moon.radiusVector.value
        let sunDistanceFromMoon = abs(sunDistanceFromEarth - moonDistanceFromEarth)
        
        return CelestialBody(
            name: "Sun",
            distanceFromEarth: sunDistanceFromEarth,
            distanceFromSun: nil,  // Not applicable for the Sun
            distanceFromMoon: sunDistanceFromMoon,
            phase: nil,
            phaseDescription: nil,
            currentPhase: nil,
            riseTime: nil,
            setTime: nil,
            azimuth: nil
        )
    }
    
    func fetchMoonData(for date: Date = Date()) -> CelestialBody {
        let julianDay = JulianDay(date)
        let moon = Moon(julianDay: julianDay)
        let sun = Sun(julianDay: julianDay)
        
        let moonDistanceFromEarth = moon.radiusVector.value
        let moonDistanceFromSun = abs(sun.radiusVector.value - moonDistanceFromEarth)
        
        // 1. Get next full moon's Julian Day and format it:
        let nextFullMoonJulian = moon.time(of: .fullMoon)
        let fullMoonDate = nextFullMoonJulian.date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        let nextFullMoonDescription = formatter.string(from: fullMoonDate)
        
        // 2. Compute the current phase of the Moon:
        // Get the previous and next new moons to compute the phase fraction.
        let previousNewMoon = moon.time(of: .newMoon, forward: false)
        let nextNewMoon = moon.time(of: .newMoon, forward: true)
        let synodicMonth = nextNewMoon.value - previousNewMoon.value
        let currentFraction = (julianDay.value - previousNewMoon.value) / synodicMonth
        let currentPhaseDescription = moonPhaseDescription(from: currentFraction)
        
        return CelestialBody(
            name: "Moon",
            distanceFromEarth: moonDistanceFromEarth,
            distanceFromSun: moonDistanceFromSun,
            distanceFromMoon: nil,  // Not applicable for the Moon
            phase: nil,
            phaseDescription: "Next full moon: \(nextFullMoonDescription)",
            currentPhase: "Current phase: \(currentPhaseDescription)",
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
            distanceFromEarth: 0.0,  // Earth's distance from itself is zero
            distanceFromSun: earthDistanceFromSun,
            distanceFromMoon: earthDistanceFromMoon,
            phase: nil,
            phaseDescription: nil,
            currentPhase: nil,
            riseTime: nil,
            setTime: nil,
            azimuth: nil
        )
    }
    
    // Helper function to convert a phase fraction into a descriptive string.
    private func moonPhaseDescription(from fraction: Double) -> String {
        switch fraction {
        case 0..<0.03, 0.97...1:
            return "New Moon"
        case 0.03..<0.22:
            return "Waxing Crescent"
        case 0.22..<0.28:
            return "First Quarter"
        case 0.28..<0.47:
            return "Waxing Gibbous"
        case 0.47..<0.53:
            return "Full Moon"
        case 0.53..<0.72:
            return "Waning Gibbous"
        case 0.72..<0.78:
            return "Last Quarter"
        default:
            return "Waning Crescent"
        }
    }
}
