//
//  SceneKitView.swift
//  PointCloudViewer
//
//  Created by Shubham Patel on 06/07/2024.
//

import SwiftUI

struct Point3D {
    let x: Float
    let y: Float
    let z: Float
    let size: CGFloat // Size of the point
    let color: UIColor // Color of the point
}

import SwiftUI
import SceneKit

struct SceneKitView: UIViewRepresentable {
    @Binding var points: [Point3D]
    @Binding var pointSize: Double

    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = true
        scnView.scene = SCNScene()
        
        renderPoints(points, in: scnView.scene!)
        
        return scnView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        renderPoints(points, in: uiView.scene!)
    }
    
    private func renderPoints(_ points: [Point3D], in scene: SCNScene) {
        scene.rootNode.childNodes.forEach { $0.removeFromParentNode() }
        
        let pointCloud = SCNNode()
        for point in points {
            let sphere = SCNSphere(radius: point.size)
            sphere.firstMaterial?.diffuse.contents = point.color
            let sphereNode = SCNNode(geometry: sphere)
            sphereNode.position = SCNVector3(point.x, point.y, point.z)
            pointCloud.addChildNode(sphereNode)
        }
        scene.rootNode.addChildNode(pointCloud)
    }
}
