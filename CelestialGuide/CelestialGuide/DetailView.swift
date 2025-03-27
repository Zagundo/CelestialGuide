import SwiftUI

struct DetailView: View {
    let celestialBody: CelestialBody
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(celestialBody.name)
                .font(.largeTitle)
                .bold()
            
            if let distanceFromEarth = celestialBody.distanceFromEarth {
                Text("Distance from Earth: \(distanceFromEarth)")
            }
            if let distanceFromSun = celestialBody.distanceFromSun {
                Text("Distance from Sun: \(distanceFromSun)")
            }
            // Additional details can be added here
        }
        .padding()
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Provide a sample CelestialBody to preview DetailView
        DetailView(celestialBody: CelestialBody(
            name: "Test Body",
            distanceFromEarth: 100.0,
            distanceFromSun: 150.0,
            phase: 0.5,
            riseTime: nil,
            setTime: nil,
            azimuth: nil
        ))
    }
}
