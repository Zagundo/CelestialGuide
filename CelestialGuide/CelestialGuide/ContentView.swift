import SwiftUI

struct ContentView: View {
    @State private var sun = CelestialBody(name: "Sun")
    @State private var moon = CelestialBody(name: "Moon")
    @State private var earth = CelestialBody(name: "Earth")
    
    let astronomyManager = AstronomyManager()
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Sun", destination: DetailView(celestialBody: sun))
                NavigationLink("Moon", destination: DetailView(celestialBody: moon))
                NavigationLink("Earth", destination: DetailView(celestialBody: earth))
            }
            .navigationTitle("Celestial Guide")
        }
        .onAppear {
            print("onAppear called")
            sun = astronomyManager.fetchSunData()
            moon = astronomyManager.fetchMoonData()
            earth = astronomyManager.fetchEarthData()
        }
    }
}
