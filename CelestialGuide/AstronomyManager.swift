import Foundation
import SwiftAA       // Our astronomical library
import CoreLocation  // For working with Core Location data

// MARK: - Helper Extension for GeographicCoordinates
// This extension converts a Core Location CLLocation into SwiftAA’s GeographicCoordinates.
extension GeographicCoordinates {
    init(from location: CLLocation) {
        // According to the documentation, we need:
        // - A positively westward longitude. The provided init expects a negative longitude if your CLLocation's longitude is positive.
        let lon = Degree(-location.coordinate.longitude)
        let lat = Degree(location.coordinate.latitude)
        let alt = Meter(location.altitude)
        self.init(positivelyWestwardLongitude: lon, latitude: lat, altitude: alt)
    }
}

// MARK: - AstronomyManager Class
class AstronomyManager {
    
    // ============================================================
    // MARK: - Existing Functions: Fetching Basic Celestial Data
    // ============================================================
    
    func fetchSunData(for date: Date = Date(), location: GeographicCoordinates? = nil) -> CelestialBody {
        let jd = JulianDay(date)
        let sun = Sun(julianDay: jd)
        let moon = Moon(julianDay: jd)
        
        let sunDistanceFromEarth = sun.radiusVector.value    // Using radiusVector for distance
        let moonDistanceFromEarth = moon.radiusVector.value
        let sunDistanceFromMoon = abs(sunDistanceFromEarth - moonDistanceFromEarth)
        
        // Prepare placeholders for rise/set and azimuth.
        var sunrise: Date? = nil
        var sunset: Date? = nil
        var sunAzimuth: Double? = nil
        
        // If a location is provided, compute sunrise, sunset, and the sun’s azimuth at sunrise.
        if let loc = location {
            if let sr = findSunriseTime(for: date, location: loc) {
                sunrise = sr
                // Compute the sun's horizontal coordinates at sunrise:
                _ = altitudeForSun(at: sr, location: loc)
                // For demonstration, we extract the azimuth at that time.
                sunAzimuth = horizontalAzimuthForSun(at: sr, location: loc)
            }
            if let ss = findSunsetTime(for: date, location: loc) {
                sunset = ss
            }
        }
        
        // Perihelion and Aphelion for the Sun/Earth system can be approximated.
        let perihelion = 147100000.0  // in kilometers (approximate)
        let aphelion = 152100000.0    // in kilometers (approximate)
        
        return CelestialBody(
            name: "Sun",
            distanceFromEarth: sunDistanceFromEarth,
            distanceFromSun: nil,  // Not applicable for the Sun itself
            distanceFromMoon: sunDistanceFromMoon,
            phase: nil,
            phaseDescription: nil,
            currentPhase: nil,
            riseTime: sunrise,
            setTime: sunset,
            azimuth: sunAzimuth,
            // Additional orbital data:
            perihelion: perihelion,
            aphelion: aphelion,
            perigee: nil,
            apogee: nil,
            axialTilt: nil
        )
    }
    
    func fetchMoonData(for date: Date = Date(), location: GeographicCoordinates? = nil) -> CelestialBody {
        let jd = JulianDay(date)
        let moon = Moon(julianDay: jd)
        let sun = Sun(julianDay: jd)
        
        let moonDistanceFromEarth = moon.radiusVector.value
        let moonDistanceFromSun = abs(sun.radiusVector.value - moonDistanceFromEarth)
        
        // 1. Next Full Moon (as before):
        let nextFullMoonJulian = moon.time(of: .fullMoon)
        let fullMoonDate = nextFullMoonJulian.date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        let nextFullMoonDescription = formatter.string(from: fullMoonDate)
        
        // 2. Compute the current phase of the Moon (as before):
        let previousNewMoon = moon.time(of: .newMoon, forward: false)
        let nextNewMoon = moon.time(of: .newMoon, forward: true)
        let synodicMonth = nextNewMoon.value - previousNewMoon.value
        let currentFraction = (jd.value - previousNewMoon.value) / synodicMonth
        let currentPhaseDescription = moonPhaseDescription(from: currentFraction)
        
        // For Moon rise/set times and azimuth, we use similar methods if location is provided.
        var moonrise: Date? = nil
        var moonset: Date? = nil
        var moonAzimuth: Double? = nil
        
        if let loc = location {
            // For demonstration, assume a window for moonrise (e.g., 2:00 AM to 6:00 AM) and moonset (e.g., 6:00 PM to 10:00 PM).
            if let mr = findMoonRiseTime(for: date, location: loc) {
                moonrise = mr
                moonAzimuth = horizontalAzimuthForMoon(at: mr, location: loc)
            }
            if let ms = findMoonSetTime(for: date, location: loc) {
                moonset = ms
            }
        }
        
        // Perigee and Apogee for the Moon:
        let perigeeJD = moon.perigee(true)  // using mean value
        let apogeeJD = moon.apogee(true)
        let perigee = perigeeJD.value  // you may convert to Date if desired
        let apogee = apogeeJD.value
        
        return CelestialBody(
            name: "Moon",
            distanceFromEarth: moonDistanceFromEarth,
            distanceFromSun: moonDistanceFromSun,
            distanceFromMoon: nil,  // Not applicable for the Moon
            phase: nil,
            phaseDescription: "Next full moon: \(nextFullMoonDescription)",
            currentPhase: "Current phase: \(currentPhaseDescription)",
            riseTime: moonrise,
            setTime: moonset,
            azimuth: moonAzimuth,
            // Orbital extremes for the Moon:
            perihelion: nil,
            aphelion: nil,
            perigee: perigee,
            apogee: apogee,
            axialTilt: nil
        )
    }
    
    func fetchEarthData(for date: Date = Date(), location: GeographicCoordinates? = nil) -> CelestialBody {
        let jd = JulianDay(date)
        let sun = Sun(julianDay: jd)
        let moon = Moon(julianDay: jd)
        
        let earthDistanceFromSun = sun.radiusVector.value
        let earthDistanceFromMoon = moon.radiusVector.value
        
        // For Earth, we can use the Sun's rise/set as a proxy (if location is provided).
        var sunrise: Date? = nil
        var sunset: Date? = nil
        var sunAzimuth: Double? = nil
        if let loc = location {
            sunrise = findSunriseTime(for: date, location: loc)
            sunset = findSunsetTime(for: date, location: loc)
            sunAzimuth = horizontalAzimuthForSun(at: sunrise ?? date, location: loc)
        }
        
        // Perihelion and Aphelion of Earth's orbit:
        let perihelion = 147100000.0
        let aphelion = 152100000.0
        
        // Earth's axial tilt is approximately 23.4° (could be refined later)
        let axialTilt = 23.4
        
        return CelestialBody(
            name: "Earth",
            distanceFromEarth: 0.0,  // By definition
            distanceFromSun: earthDistanceFromSun,
            distanceFromMoon: earthDistanceFromMoon,
            phase: nil,
            phaseDescription: nil,
            currentPhase: nil,
            riseTime: sunrise,
            setTime: sunset,
            azimuth: sunAzimuth,
            perihelion: perihelion,
            aphelion: aphelion,
            perigee: nil,
            apogee: nil,
            axialTilt: axialTilt
        )
    }
    
    // ============================================================
    // MARK: - Helper Functions for Altitude and Azimuth Calculations
    // ============================================================
    
    /// Returns the altitude (in degrees) of the Sun at a given time and observer location.
    func altitudeForSun(at date: Date, location: GeographicCoordinates) -> Degree {
        let jd = JulianDay(date)
        let sun = Sun(julianDay: jd)
        let apparentEquatorial = sun.apparentEquatorialCoordinates
        let horizontal = apparentEquatorial.makeHorizontalCoordinates(for: location, at: jd)
        return horizontal.altitude
    }
    
    /// Returns the horizontal (local) azimuth of the Sun at a given time and location.
    func horizontalAzimuthForSun(at date: Date, location: GeographicCoordinates) -> Double {
        let jd = JulianDay(date)
        let sun = Sun(julianDay: jd)
        let apparentEquatorial = sun.apparentEquatorialCoordinates
        let horizontal = apparentEquatorial.makeHorizontalCoordinates(for: location, at: jd)
        // The azimuth is given as a Degree; we return its value.
        return horizontal.azimuth.value
    }
    
    /// Returns the altitude (in degrees) of the Moon at a given time and observer location.
    func altitudeForMoon(at date: Date, location: GeographicCoordinates) -> Degree {
        let jd = JulianDay(date)
        let moon = Moon(julianDay: jd)
        let apparentEquatorial = moon.apparentEquatorialCoordinates
        let horizontal = apparentEquatorial.makeHorizontalCoordinates(for: location, at: jd)
        return horizontal.altitude
    }
    
    /// Returns the horizontal azimuth of the Moon at a given time and location.
    func horizontalAzimuthForMoon(at date: Date, location: GeographicCoordinates) -> Double {
        let jd = JulianDay(date)
        let moon = Moon(julianDay: jd)
        let apparentEquatorial = moon.apparentEquatorialCoordinates
        let horizontal = apparentEquatorial.makeHorizontalCoordinates(for: location, at: jd)
        return horizontal.azimuth.value
    }
    
    // ============================================================
    // MARK: - Binary Search for Rise/Set Times
    // ============================================================
    
    /// Finds the time when the Sun's altitude crosses a target altitude within a given interval.
    /// - Parameters:
    ///   - start: The beginning of the time interval.
    ///   - end: The end of the time interval.
    ///   - location: The observer's geographic coordinates.
    ///   - targetAltitude: The altitude (in degrees) to search for.
    ///   - rising: A Boolean indicating whether we're looking for a rising (true) or setting (false) event.
    /// - Returns: The Date when the altitude equals the target, or nil if not found.
    func findSunTime(start: Date, end: Date, location: GeographicCoordinates, targetAltitude: Degree, rising: Bool = true) -> Date? {
        let tolerance: TimeInterval = 10.0  // seconds
        var lowerBound = start
        var upperBound = end
        var midTime = start
        
        let altStart = altitudeForSun(at: lowerBound, location: location)
        let altEnd = altitudeForSun(at: upperBound, location: location)
        
        // For sunrise (rising), we expect altStart < target < altEnd.
        // For sunset (setting), we expect altStart > target > altEnd.
        if rising {
            if !(altStart < targetAltitude && altEnd > targetAltitude) {
                print("Sunrise: Target altitude not bracketed in the interval.")
                return nil
            }
        } else {
            if !(altStart > targetAltitude && altEnd < targetAltitude) {
                print("Sunset: Target altitude not bracketed in the interval.")
                return nil
            }
        }
        
        while upperBound.timeIntervalSince(lowerBound) > tolerance {
            midTime = lowerBound.addingTimeInterval(upperBound.timeIntervalSince(lowerBound) / 2)
            let midAlt = altitudeForSun(at: midTime, location: location)
            
            if rising {
                if midAlt < targetAltitude {
                    lowerBound = midTime
                } else {
                    upperBound = midTime
                }
            } else {
                if midAlt > targetAltitude {
                    lowerBound = midTime
                } else {
                    upperBound = midTime
                }
            }
        }
        return midTime
    }
    
    /// Finds the sunrise time for the Sun on a given date and location.
    func findSunriseTime(for date: Date, location: GeographicCoordinates) -> Date? {
        let calendar = Calendar.current
        var startComponents = calendar.dateComponents([.year, .month, .day], from: date)
        startComponents.hour = 6
        startComponents.minute = 0
        guard let startTime = calendar.date(from: startComponents) else { return nil }
        
        var endComponents = startComponents
        endComponents.hour = 8
        guard let endTime = calendar.date(from: endComponents) else { return nil }
        
        let targetAltitude = ArcMinute(-50).inDegrees  // as provided for the Sun
        return findSunTime(start: startTime, end: endTime, location: location, targetAltitude: targetAltitude, rising: true)
    }
    
    /// Finds the sunset time for the Sun on a given date and location.
    func findSunsetTime(for date: Date, location: GeographicCoordinates) -> Date? {
        let calendar = Calendar.current
        var startComponents = calendar.dateComponents([.year, .month, .day], from: date)
        startComponents.hour = 16
        startComponents.minute = 0
        guard let startTime = calendar.date(from: startComponents) else { return nil }
        
        var endComponents = startComponents
        endComponents.hour = 18
        guard let endTime = calendar.date(from: endComponents) else { return nil }
        
        let targetAltitude = ArcMinute(-50).inDegrees
        return findSunTime(start: startTime, end: endTime, location: location, targetAltitude: targetAltitude, rising: false)
    }
    
    // Similar binary search functions for the Moon's rise/set could be implemented.
    // For example:
    func findMoonTime(start: Date, end: Date, location: GeographicCoordinates, targetAltitude: Degree, rising: Bool = true) -> Date? {
        let tolerance: TimeInterval = 10.0
        var lowerBound = start
        var upperBound = end
        var midTime = start
        
        let altStart = altitudeForMoon(at: lowerBound, location: location)
        let altEnd = altitudeForMoon(at: upperBound, location: location)
        
        if rising {
            if !(altStart < targetAltitude && altEnd > targetAltitude) {
                print("Moonrise: Target altitude not bracketed.")
                return nil
            }
        } else {
            if !(altStart > targetAltitude && altEnd < targetAltitude) {
                print("Moonset: Target altitude not bracketed.")
                return nil
            }
        }
        
        while upperBound.timeIntervalSince(lowerBound) > tolerance {
            midTime = lowerBound.addingTimeInterval(upperBound.timeIntervalSince(lowerBound) / 2)
            let midAlt = altitudeForMoon(at: midTime, location: location)
            
            if rising {
                if midAlt < targetAltitude {
                    lowerBound = midTime
                } else {
                    upperBound = midTime
                }
            } else {
                if midAlt > targetAltitude {
                    lowerBound = midTime
                } else {
                    upperBound = midTime
                }
            }
        }
        return midTime
    }
    
    func findMoonRiseTime(for date: Date, location: GeographicCoordinates) -> Date? {
        let calendar = Calendar.current
        var startComponents = calendar.dateComponents([.year, .month, .day], from: date)
        startComponents.hour = 4
        startComponents.minute = 0
        guard let startTime = calendar.date(from: startComponents) else { return nil }
        
        var endComponents = startComponents
        endComponents.hour = 8
        guard let endTime = calendar.date(from: endComponents) else { return nil }
        
        // Use Moon's apparentRiseSetAltitude (as defined in SwiftAA)
        let targetAltitude = Moon.apparentRiseSetAltitude
        return findMoonTime(start: startTime, end: endTime, location: location, targetAltitude: targetAltitude, rising: true)
    }
    
    func findMoonSetTime(for date: Date, location: GeographicCoordinates) -> Date? {
        let calendar = Calendar.current
        var startComponents = calendar.dateComponents([.year, .month, .day], from: date)
        startComponents.hour = 18
        startComponents.minute = 0
        guard let startTime = calendar.date(from: startComponents) else { return nil }
        
        var endComponents = startComponents
        endComponents.hour = 22
        guard let endTime = calendar.date(from: endComponents) else { return nil }
        
        let targetAltitude = Moon.apparentRiseSetAltitude
        return findMoonTime(start: startTime, end: endTime, location: location, targetAltitude: targetAltitude, rising: false)
    }
    
    // ============================================================
    // MARK: - Existing Helper: Moon Phase Description
    // ============================================================
    
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
