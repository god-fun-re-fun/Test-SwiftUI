//
//  TestView4.swift
//  Scene
//
//  Created by 이조은 on 11/27/23.
//

import SwiftUI
import SceneKit
import SpriteKit

struct TestView4: View {
    @State private var rotate = false

    var body: some View {
        VStack {
            SceneKitView2(rotate: $rotate)
        }
    }
}

struct SceneKitView2: UIViewRepresentable {
    @Binding var rotate: Bool

    func makeUIView(context: Context) -> SCNView {
        let scene = SCNScene(named: "head05.scn")
        // MARK: - 크기 조절
        let sphere = SCNSphere(radius: 1.0)
        let node = SCNNode(geometry: sphere)
        // MARK: - 카메라 위치 조절
        /// SCNNode의 position 속성을 통해 3D 오브젝트의 위치를 설정
        /// SCNVector3(x, y, z)에서 x, y, z는 각각 오브젝트의 x축, y축, z축 위치를 나타냅니다.
        /// z축 값이 클수록 사용자로부터 멀어지고, 작을수록 사용자에게 가까워집니다.
        node.position = SCNVector3(0, 0, -5)
        scene?.rootNode.addChildNode(node)
        /// 3D 오브젝트의 크기를 절반으로 줄임
        scene?.rootNode.scale = SCNVector3(0.3, 0.3, 0.3)

        // 배경 이미지 설정
        let backgroundImage = UIImage(named: "asphalt.jpg") // 여기에 실제 이미지 파일 이름을 입력해 주세요.
        let skScene = SKScene(size: CGSize(width: 500, height: 500))
        let backgroundNode = SKSpriteNode(texture: SKTexture(image: backgroundImage!))
        backgroundNode.size = skScene.size
        backgroundNode.position = CGPoint(x: skScene.size.width / 2.0, y: skScene.size.height / 2.0)
        skScene.addChild(backgroundNode)

        let scnView = SCNView()
        context.coordinator.scnView = scnView
        scnView.scene = scene
        scnView.allowsCameraControl = false
        scnView.autoenablesDefaultLighting = true
        scnView.backgroundColor = UIColor.clear

        scnView.scene?.background.contents = skScene

        // 카메라 위치 변경
        //        let cameraNode = SCNNode()
        //        cameraNode.camera = SCNCamera()
        //        // 여기에서 x, y, z 값을 변경하여 카메라의 위치를 조절할 수 있습니다.
        //        cameraNode.position = SCNVector3(x: 0, y: 40, z: 140)
        //        scnView.pointOfView = cameraNode

        let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePan(_:)))
        scnView.addGestureRecognizer(panGesture)

        return scnView
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func updateUIView(_ scnView: SCNView, context: Context) {
        if rotate {
            // MARK: - 속도 조절하는 부분
            /// (duration 값을 줄이면 회전 속도가 빨라진다.)
            let rotationAction = SCNAction.rotate(by: .pi * 3, around: SCNVector3(1, 0, 0), duration: 2)

            scnView.scene?.rootNode.childNodes.forEach { node in
                node.runAction(rotationAction)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                rotate = false
            }
        }
    }

    class Coordinator: NSObject {
        var view: SceneKitView2
        var scnView: SCNView?

        init(_ view: SceneKitView2) {
            self.view = view
        }

        @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
            if gesture.state == .changed {
                //print("회전 이벤트 발생")
                let translation = gesture.translation(in: gesture.view)
                DispatchQueue.main.async {
                    // 사용자가 위로 드래그하면 translation.y는 음수가 되고, 아래로 드래그하면 양수
                    if abs(translation.y) > 50 {
                        // 스크롤 방향에 따른 메시지 출력
                        if translation.y > 0 {
                            print("위로 올라가는 스크롤")

                        } else {
                            print("밑으로 내려가는 스크롤")
                        }
                        // 이벤트를 처리한 후에는 translation을 초기화합니다.
                        //gesture.setTranslation(.zero, in: gesture.view)
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

struct TestView4_Previews: PreviewProvider {
    static var previews: some View {
        TestView4()
    }
}

