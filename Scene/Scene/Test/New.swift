//
//  New.swift
//  Scene
//
//  Created by 이조은 on 12/5/23.
//

import SwiftUI
import SceneKit

struct New: View {
    var body: some View {
        let scene = SCNScene()
        scene.background.contents = UIColor.black

        let firstNode = SCNNode()
        let secondNode = SCNNode()

        if let firstModel = SCNScene(named: "glass_head.scn"),
           let secondModel = SCNScene(named: "Asphalt_withCrack.scn") {
            let sceneNodeArray = firstModel.rootNode.childNodes

            for childNode in sceneNodeArray {
                firstNode.addChildNode(childNode as SCNNode)
            }

            let secondSceneNodeArray = secondModel.rootNode.childNodes

            for childNode in secondSceneNodeArray {
                secondNode.addChildNode(childNode as SCNNode)
            }

            firstNode.scale = SCNVector3(0.5, 0.5, 0.5) // 크기를 2배로 조정

            secondNode.scale = SCNVector3(20, 20, 20) // 크기를 2배로 조정
            secondNode.position.z = 30 // z축을 이용하여 더 뒤에 위치하게 함

            scene.rootNode.addChildNode(firstNode)
            scene.rootNode.addChildNode(secondNode)
        }


        // 카메라 위치
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        scene.rootNode.addChildNode(cameraNode)

        return SceneView(scene: scene, options: [.autoenablesDefaultLighting, .allowsCameraControl])
            .edgesIgnoringSafeArea(.all)
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onChanged { _ in
                    let rotateAction = SCNAction.rotateBy(x: CGFloat(Double.pi), y: 0, z: 0, duration: 1)
                    firstNode.runAction(rotateAction)
                }
            )
    }
}

struct New_Previews: PreviewProvider {
    static var previews: some View {
        New()
    }
}
