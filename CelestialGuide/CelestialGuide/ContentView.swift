import SwiftUI
import SwiftAA
import CoreLocation

struct ContentView: View {
    @State private var sun = CelestialBody(name: "Sun")
    @State private var moon = CelestialBody(name: "Moon")
    @State private var earth = CelestialBody(name: "Earth")
    
    // Create instances of AstronomyManager and LocationManager
    let astronomyManager = AstronomyManager()
    @ObservedObject var locationManager = LocationManager()
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: DetailView(celestialBody: sun)) {
                    VStack(alignment: .leading) {
                        Text("Sun")
                            .font(.headline)
                        if let sunrise = sun.riseTime {
                            Text("Sunrise: \(formattedDate(sunrise))")
                                .font(.subheadline)
                        }
                        if let azimuth = sun.azimuth {
                            Text("Azimuth: \(azimuth, specifier: "%.1f")°")
                                .font(.subheadline)
                        }
                    }
                }
                NavigationLink(destination: DetailView(celestialBody: moon)) {
                    VStack(alignment: .leading) {
                        Text("Moon")
                            .font(.headline)
                        if let phaseDesc = moon.phaseDescription {
                            Text(phaseDesc)
                                .font(.subheadline)
                        }
                        if let currentPhase = moon.currentPhase {
                            Text(currentPhase)
                                .font(.subheadline)
                        }
                    }
                }
                NavigationLink(destination: DetailView(celestialBody: earth)) {
                    VStack(alignment: .leading) {
                        Text("Earth")
                            .font(.headline)
                        if let sunrise = earth.riseTime {
                            Text("Sunrise: \(formattedDate(sunrise))")
                                .font(.subheadline)
                        }
                    }
                }
            }
            .navigationTitle("Celestial Guide")
        }
        .onAppear {
            // Initial attempt: if location is available, update data.
            if let clLocation = locationManager.currentLocation {
                updateCelestialData(with: clLocation)
            } else {
                print("Location not available yet.")
            }
        }
        // Update celestial data as soon as a valid location is received.
        .onChange(of: locationManager.currentLocation) { newLocation, oldLocation in
            if let clLocation = newLocation {
                updateCelestialData(with: clLocation)
            }
        }
    }
    
    // Helper method to update celestial data using a CLLocation
    private func updateCelestialData(with clLocation: CLLocation) {
        let geoCoordinates = GeographicCoordinates(from: clLocation)
        sun = astronomyManager.fetchSunData(for: Date(), location: geoCoordinates)
        moon = astronomyManager.fetchMoonData(for: Date(), location: geoCoordinates)
        earth = astronomyManager.fetchEarthData(for: Date(), location: geoCoordinates)
    }
    
    // Helper function to format Date to a readable string.
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
