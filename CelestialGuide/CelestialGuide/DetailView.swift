import SwiftUI

struct DetailView: View {
    let celestialBody: CelestialBody
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(celestialBody.name)
                .font(.largeTitle)
                .bold()
            
            if let distanceFromEarth = celestialBody.distanceFromEarth {
                Text("Distance from Earth: \(distanceFromEarth) km")
            }
            if let distanceFromSun = celestialBody.distanceFromSun {
                Text("Distance from Sun: \(distanceFromSun) km")
            }
            if let distanceFromMoon = celestialBody.distanceFromMoon {
                Text("Distance from Moon: \(distanceFromMoon) km")
            }
            if let phaseDesc = celestialBody.phaseDescription {
                Text(phaseDesc)
            }
            if let currentPhase = celestialBody.currentPhase {
                Text(currentPhase)
            }
        }
        .padding()
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(celestialBody: CelestialBody(
            name: "Moon",
            distanceFromEarth: 384400,
            distanceFromSun: 150000000,
            distanceFromMoon: nil,
            phase: nil,
            phaseDescription: "Next full moon: Jan 15, 2026 at 9:30 PM",
            currentPhase: "Current phase: Waxing Crescent",
            riseTime: nil,
            setTime: nil,
            azimuth: nil
        ))
    }
}
