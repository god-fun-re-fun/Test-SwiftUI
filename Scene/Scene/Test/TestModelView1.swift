import SwiftUI
import _SceneKit_SwiftUI
import SceneKit

struct TestModelView1: View {
    @State var rotationDuration: TimeInterval = 2.0

    var body: some View {
        VStack {
            if rotationDuration > 6.0 {
                AnimationView()
                    .transition(.opacity)
            } else {
                TestModel(rotationDuration: $rotationDuration)
                    .transition(.opacity)
                    .edgesIgnoringSafeArea(.all)
                    .background(Color.black)
            }
        }
    }
}

struct TestModel: View {

    @State var index = 0
    @State var isRolling = false
    @State var lastDragAmount: CGFloat = 0
    @Binding var rotationDuration: TimeInterval
    @State var rotationPi: Double = .pi

    @State var glassHead: SCNScene? = SCNScene(named: "head05.scn") // Add this line

    var body: some View {
        let crackScene = SCNScene(named: "Asphalt_withCrack.scn")

        let backgroundImage = UIImage(named: "asphalt")
        glassHead?.background.contents = backgroundImage
        crackScene?.background.contents = UIColor.black

        return ScrollView {
            ZStack {
                // Background
                SceneView(scene: crackScene, options: [.autoenablesDefaultLighting, .allowsCameraControl])
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: UIScreen.main.bounds.width*2, height: UIScreen.main.bounds.height*2)
                    .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
                    .gesture(
                        DragGesture()
                            .onChanged { change in
                                if change.translation.height > 0 {
                                    withAnimation {
                                        self.rotationDuration -= 0.6
                                    }
                                    let rotationAction = SCNAction.rotate(by: .pi*2, around: SCNVector3(1, 1, 0), duration: self.rotationDuration)
                                    glassHead?.rootNode.runAction(rotationAction)
                                    print("위로 올라가는: \(rotationDuration)")
                                } else if change.translation.height < 0 {
                                    withAnimation {
                                        self.rotationDuration += 0.6
                                    }
                                    let rotationAction = SCNAction.rotate(by: .pi*2, around: SCNVector3(1, 1, 0), duration: self.rotationDuration)
                                    glassHead?.rootNode.runAction(rotationAction)
                                    print("아래로 내려가는: \(rotationDuration)")
                                }
                            }
                    )

                // Front
                SceneView(scene: glassHead, options: [.autoenablesDefaultLighting,.allowsCameraControl])
                    .frame(width: UIScreen.main.bounds.width/4+80 , height: UIScreen.main.bounds.height/4, alignment: .center)
                    .background(Color.clear)
                    .clipShape(Circle())
                    .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
            }
        }
    }
}

struct TestModelView1_Previews: PreviewProvider {
    static var previews: some View {
        TestModelView1()
    }
}
