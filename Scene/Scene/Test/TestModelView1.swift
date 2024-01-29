import SwiftUI
import _SceneKit_SwiftUI
import SceneKit

struct TestModelView1: View {
    @State var rotationDuration: TimeInterval = 2.0
    
    var body: some View {
        VStack {
            TestModel(rotationDuration: $rotationDuration)
                .transition(.opacity)
                .edgesIgnoringSafeArea(.all)
                .background(Color.black)
        }
    }
}

struct TestModel: View {
    
    @State var index = 0
    @State var isRolling = false
    @State var lastDragAmount: CGFloat = 0
    @Binding var rotationDuration: TimeInterval
    @State var rotationPi: Double = .pi
    @State private var timer: Timer? = nil

    @State var velocity: CGFloat = 30

    @State var glassHead: SCNScene? = SCNScene(named: "head05.scn") // Add this line
    
    @State var red: CGFloat = 0.5
    @State var green: CGFloat = 0.5
    @State var blue: CGFloat = 0.5
    let alpha: CGFloat = 1.0
    
    var body: some View {
        let crackScene = SCNScene(named: "Asphalt_withCrack-All-SphereOnly-Plane.usdz")
        
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
                                self.timer?.invalidate()
                                self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                                    print("no event")
                                    changeAnimation(0.5, 0.5, 0.5)
                                }
                                
                                if change.translation.height > 0 {
                                    print("위")
                                    changeAnimation(0.5, 0.5, 1.0)
                                    withAnimation {
                                        self.rotationDuration -= 0.6
                                    }
                                    let rotationAction = SCNAction.rotate(by: .pi*2, around: SCNVector3(1, 0, 0), duration: self.rotationDuration)
                                    // 속도 갱신
                                    glassHead?.rootNode.runAction(rotationAction)
                                    print("위로 올라가는: \(velocity)")
                                } else if change.translation.height < 0 {
                                    changeAnimation(1.0, 0.5, 0.5)
                                    withAnimation {
                                        self.rotationDuration += 0.6
                                    }
                                    let rotationAction = SCNAction.rotate(by: .pi*2, around: SCNVector3(1, 0, 0), duration: self.rotationDuration)
                                    glassHead?.rootNode.runAction(rotationAction)
                                    print("아래로 내려가는: \(velocity)")
                                    print("아래")
                                } else if change.translation.width > 0 {
                                    print("오른쪽")
                                } else if change.translation.width < 0 {
                                    print("왼쪽")
                                }
                            }
                            .onEnded { _ in
                                // 사용자가 드래그를 끝내면 타이머를 초기화
                                self.timer?.invalidate()
                                self.timer = nil
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

    // 색상 변경 함수
    func changeColor(_ goalRed: CGFloat, _ goalGreen: CGFloat, _ goalBlue: CGFloat) -> UIColor {
        print("=== color change func 🎨 ===")
        let newRed = self.red + (goalRed - self.red)/velocity
        self.red = newRed
        let newGreen = self.green + (goalGreen - self.green)/velocity
        self.green = newGreen
        let newBlue = self.blue + (goalBlue - self.blue)/velocity
        self.blue = newBlue

        // print("🌀🌀newBlue: \(self.blue)")
        print("🌀🌀🌀newBlue: \(self.blue + (goalBlue - self.blue)/velocity)")

        let newColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return newColor
    }

    func changeAnimation(_ goalRed: CGFloat, _ goalGreen: CGFloat, _ goalBlue: CGFloat) {
        print("=== changeAnimation func 📽️ ===")
        glassHead?.rootNode.enumerateChildNodes { node, _ in
            node.geometry?.materials.forEach { material in
                let newColor = changeColor(goalRed, goalGreen, goalBlue)

                // SCNTransaction을 사용하여 애니메이션 적용
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5 // 애니메이션 지속 시간 설정
                material.diffuse.contents = newColor
                SCNTransaction.commit()
            }
        }
    }
}

struct TestModelView1_Previews: PreviewProvider {
    static var previews: some View {
        TestModelView1()
    }
}
