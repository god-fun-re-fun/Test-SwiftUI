//
//  TestView3.swift
//  Scene
//
//  Created by 이조은 on 2023/11/21.
//

import SwiftUI
import SceneKit

struct TestView3: View {
    @State private var rotation: CGFloat = 0.0

    var body: some View {
        ZStack {
            Color.gray
            SceneKitView(rotation: $rotation)
        }
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { value in
                        rotation += value.translation.width
                    })
    }
}

struct SceneKitView: UIViewRepresentable {
    @Binding var rotation: CGFloat

    func makeUIView(context: Context) -> SCNView {
        //let scene = SCNScene(named: "head.obj") // 파일명을 본인이 사용하는 3D 오브젝트 파일명으로 변경
        let scene = SCNScene(named: "glass-head-test1210.scn")
        scene?.background.contents = UIImage(named: "BG") // 배경 이미지 설정, 이미지 파일명을 본인이 사용하는 배경 이미지 파일명으로 변경
        let scnView = SCNView()
        scnView.scene = scene
        scnView.allowsCameraControl = false
        scnView.autoenablesDefaultLighting = true

        // 모든 노드의 크기를 줄임
        scnView.scene?.rootNode.childNodes.forEach { node in
            node.scale = SCNVector3(0.3, 0.3, 0.3) // 크기 조정
        }

        return scnView
    }

    func updateUIView(_ scnView: SCNView, context: Context) {
        let rotate = SCNAction.rotate(by: CGFloat(rotation) * .pi / 180, around: SCNVector3(0, 1, 0), duration: 0.1)
        scnView.scene?.rootNode.childNodes.forEach { node in
            node.runAction(rotate)
        }
        DispatchQueue.main.async {
            rotation = 0
        }
    }
}

struct TestView3_Previews: PreviewProvider {
    static var previews: some View {
        TestView3()
    }
}
