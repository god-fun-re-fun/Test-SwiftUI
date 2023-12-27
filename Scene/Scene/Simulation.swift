//
//  Simulation.swift
//  Scene
//
//  Created by 이조은 on 12/7/23.
//

import SwiftUI
import SceneKit
import SpriteKit

struct Simulation: View {
    @State private var rotate = false

    var body: some View {
        VStack {
            SimulationSceneKitView(rotate: $rotate)
        }
    }
}

struct SimulationSceneKitView: UIViewRepresentable {
    @Binding var rotate: Bool

    func makeUIView(context: Context) -> SCNView {
        let scene = SCNScene(named: "glass_head.scn")
        // MARK: - 크기 조절
        let sphere = SCNSphere(radius: 1.0)
        let node = SCNNode(geometry: sphere)
        node.position = SCNVector3(0, 0, -5)
        scene?.rootNode.addChildNode(node)
        scene?.rootNode.scale = SCNVector3(0.2, 0.2, 0.2)

        let scnView = SCNView()
        scnView.scene = scene
        scnView.allowsCameraControl = false
        scnView.autoenablesDefaultLighting = true
        scnView.backgroundColor = UIColor.clear

        return scnView
    }

    func updateUIView(_ uiView: SCNView, context: Context) {

    }

}

struct Simulation_Previews: PreviewProvider {
    static var previews: some View {
        Simulation()
    }
}

