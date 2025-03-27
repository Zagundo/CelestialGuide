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
            if let distanceFromMoon = celestialBody.distanceFromMoon {
                Text("Distance from Moon: \(distanceFromMoon)")
            }
        }
        .padding()
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Provide a sample CelestialBody to preview DetailView
        DetailView(celestialBody: CelestialBody(
            name: "Preview Body",
            distanceFromEarth: 150000000,
            distanceFromSun: nil,
            distanceFromMoon: 384400,
            phase: nil,
            riseTime: nil,
            setTime: nil,
            azimuth: nil
        ))
    }
}
