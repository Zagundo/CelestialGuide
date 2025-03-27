import SwiftUI

struct ContentView: View {
    
    // Example data for demonstration
    @State private var sun = CelestialBody(name: "Sun")
    @State private var moon = CelestialBody(name: "Moon")
    @State private var earth = CelestialBody(name: "Earth")
    
    var body: some View {
        NavigationView {
            VStack {
                // Simple layout with buttons or cards
                NavigationLink(destination: DetailView(celestialBody: sun)) {
                    Text("Sun")
                }
                NavigationLink(destination: DetailView(celestialBody: moon)) {
                    Text("Moon")
                }
                NavigationLink(destination: DetailView(celestialBody: earth)) {
                    Text("Earth")
                }
            }
            .navigationTitle("Celestial Guide")
        }
    }
}

