//
//  ScorllEvent.swift
//  Scene
//
//  Created by 이조은 on 12/10/23.
//

import SwiftUI
import SceneKit
import SpriteKit

struct ScorllEvent: View {
    @State private var rotate = false

    var body: some View {
        VStack {
            SceneKitView6(rotate: $rotate)
                .edgesIgnoringSafeArea(.all)

        }
    }
}

struct SceneKitView6: UIViewRepresentable {
    @Binding var rotate: Bool

        func makeUIView(context: Context) -> SCNView {
            let glassHead = SCNScene(named: "head05.scn")
            let crackScene = SCNScene(named: "Asphalt_withCrack.scn")

            let backgroundImage = UIImage(named: "asphalt")
            glassHead?.background.contents = backgroundImage
            crackScene?.background.contents = UIColor.black

            let scene = SCNScene()

            if let glassHeadNode = glassHead?.rootNode, let crackSceneNode = crackScene?.rootNode {
                    // 각 노드의 위치를 조정합니다.
                    glassHeadNode.position = SCNVector3(0, 0, 0)
                    crackSceneNode.position = SCNVector3(0, 0, -10)

                    // 각 노드의 크기를 조정합니다.
                    glassHeadNode.scale = SCNVector3(5, 5, 5)
                    crackSceneNode.scale = SCNVector3(30, 30, 30)

                    scene.rootNode.addChildNode(glassHeadNode)
                    scene.rootNode.addChildNode(crackSceneNode)
                }

            //scene.rootNode.scale = SCNVector3(5, 5, 5)
            scene.background.contents = UIColor.black

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
        var view: SceneKitView6
        var scnView: SCNView?

        init(_ view: SceneKitView6) {
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

struct ScorllEvent_Previews: PreviewProvider {
    static var previews: some View {
        ScorllEvent()
    }
}
