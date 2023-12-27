import SwiftUI
import SceneKit

struct TestView2: View {
    var body: some View {
        GeometryReader { geometry in
            SceneView(
                scene: createScene(geometry: geometry, imageName: "BG"),
                options: [.allowsCameraControl]
            )
            .edgesIgnoringSafeArea(.all)
        }
    }

    private func createScene(geometry: GeometryProxy, imageName: String) -> SCNScene {
        let scene = SCNScene()

        scene.background.contents = UIImage(named: "BG") // 배경화면 설정

        let box = SCNBox(width: 1.0, height: 0.5, length: 0.01, chamferRadius: 0)
        box.firstMaterial?.diffuse.contents = UIImage(named: "BG")
        box.firstMaterial?.isDoubleSided = true
        let boxNode = SCNNode(geometry: box)
        boxNode.position = SCNVector3(0, 0, 0)
        scene.rootNode.addChildNode(boxNode)

        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 0, 1.5)
        scene.rootNode.addChildNode(cameraNode)

        return scene
    }
}

struct TestView2_Previews: PreviewProvider {
    static var previews: some View {
        TestView2()
    }
}
