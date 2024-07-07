//
//  ContentView.swift
//  PointCloudViewer
//
//  Created by Shubham Patel on 06/07/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var points: [Point3D] = []
    @State private var numberOfPoints: Double = 1000 // Initial number of points as Double
    @State private var pointSize: Double = 0.01 // Initial size of points
    @State private var isSizePanelVisible = false // Flag to toggle size panel visibility

    var body: some View {
        VStack {
            SceneKitView(points: $points, pointSize: $pointSize)
                .edgesIgnoringSafeArea(.all)
            
            // Size Panel
            VStack {
                HStack {
                    Text("Settings")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action: {
                        isSizePanelVisible.toggle()
                    }) {
                        Image(systemName: isSizePanelVisible ? "chevron.up" : "chevron.down")
                            .foregroundColor(.blue)
                            .font(.subheadline)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding()
                
                if isSizePanelVisible {
                    VStack(spacing: 12) {
                        SliderPanel(title: "Number of Points", value: $numberOfPoints, range: 100...2000, step: 100)
                        SliderPanel(title: "Point Size", value: $pointSize, range: 0.001...0.05, step: 0.001)
                        // Refresh Button
                        Button(action: {
                            points = spherePointCloud(nb_points: Int(numberOfPoints), pointSize: pointSize)
                        }) {
                            Text("Refresh")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding()
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
            }
            .padding()
        }
        .onAppear {
            points = spherePointCloud(nb_points: Int(numberOfPoints), pointSize: pointSize)
        }
    }
}

struct SliderPanel: View {
    var title: String
    @Binding var value: Double
    var range: ClosedRange<Double>
    var step: Double
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .padding(.bottom, 4)
            Slider(value: $value, in: range, step: step)
            Text("\(Int(value))")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func spherePointCloud(nb_points: Int, pointSize: CGFloat) -> [Point3D] {
    var points: [Point3D] = []
    let goldenRatio = (1 + sqrt(5.0)) / 2.0
    var thetas: [Float] = []
    var phis: [Float] = []
    
    for i in 0..<nb_points {
        thetas.append(2 * Float.pi * Float(i) / Float(goldenRatio))
        phis.append(acos(1 - 2 * Float(Float(i) + 0.5) / Float(nb_points)))
    }
    
    let uiColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
    
    for i in 0..<nb_points {
        let theta = thetas[i]
        let phi = phis[i]
        let x = cos(theta) * sin(phi)
        let y = sin(theta) * sin(phi)
        let z = cos(phi)
        let color = uiColor.withAlphaComponent(1.0)
        let point = Point3D(x: x, y: y, z: z, size: pointSize, color: color)
        points.append(point)
    }
    
    return points
}

#Preview {
    ContentView()
}
