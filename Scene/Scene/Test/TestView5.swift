//
//  TestView5.swift
//  Scene
//
//  Created by 이조은 on 11/27/23.
//

import SwiftUI
import SceneKit
import SpriteKit

struct TestView5: View {
    @State private var rotate = false

    var body: some View {
        VStack {
            SceneKitView5(rotate: $rotate)
                .edgesIgnoringSafeArea(.all)

        }
    }
}

struct SceneKitView5: UIViewRepresentable {
    @Binding var rotate: Bool

    func makeUIView(context: Context) -> SCNView {
        let scene = SCNScene(named: "Pluto.usdz")
        let rootNode = scene?.rootNode

        // MARK: - 크기 조절
        let sphere = SCNSphere(radius: 1)
        let node = SCNNode(geometry: sphere)
        node.position = SCNVector3(0, 0, 0)
        node.scale = SCNVector3(0.1, 0.1, 0.1)
        rootNode?.addChildNode(node)

        // 배경에 3D 구 오브젝트 추가
        let backgroundScene = SCNScene(named: "Earth.usdz")
        let backgroundNode = backgroundScene?.rootNode
        backgroundNode?.position = SCNVector3(0, 0, 2)
        backgroundNode?.scale = SCNVector3(8, 8, 8)
        rootNode?.addChildNode(backgroundNode!)

        let scnView = SCNView()
        context.coordinator.scnView = scnView
        scnView.scene = scene
        scnView.allowsCameraControl = false
        scnView.autoenablesDefaultLighting = true
        scnView.backgroundColor = UIColor.clear

        let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePan(_:)))
        scnView.addGestureRecognizer(panGesture)

        return scnView
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func updateUIView(_ scnView: SCNView, context: Context) {
        if rotate {
            let rotationAction = SCNAction.rotate(by: .pi * 0.5, around: SCNVector3(1, 0, 0), duration: 2)

            scnView.scene?.rootNode.childNodes.forEach { node in
                node.runAction(rotationAction)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                rotate = false
            }
        }
    }

    class Coordinator: NSObject {
        var view: SceneKitView5
        var scnView: SCNView?

        init(_ view: SceneKitView5) {
            self.view = view
        }

        @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
            if gesture.state == .changed {
                let translation = gesture.translation(in: gesture.view)
                DispatchQueue.main.async {
                    if abs(translation.y) > 50 {
                        if translation.y > 0 {
                            print("위로 올라가는 스크롤")
                        } else {
                            print("밑으로 내려가는 스크롤")
                        }
                        let rotationAction = SCNAction.rotate(by: .pi * 1, around: SCNVector3(1, 0, 0), duration: 15)
                        self.view.rotate = true
                        self.scnView?.scene?.rootNode.childNodes.forEach { node in
                            node.runAction(rotationAction)
                        }
                    }
                }
            }
        }
    }
}

struct TestView5_Previews: PreviewProvider {
    static var previews: some View {
        TestView5()
    }
}
