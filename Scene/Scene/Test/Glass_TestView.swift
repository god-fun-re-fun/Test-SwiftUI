//
//  TestView.swift
//  Scene
//
//  Created by 이조은 on 2023/11/14.
//

import SwiftUI
import _SceneKit_SwiftUI
import SceneKit

struct TestView: View {
    var body: some View {
        
        Test()
    }
}

struct Test : View {
    
    @State var models = [
        Model(id: 0, name: "1", modelName: "Concrete-Smooth.usdz", details: "test"),
        Model(id: 1, name: "2", modelName: "Concrete-smooth-legacy.usdz", details: "test"),
        Model(id: 2, name: "3", modelName: "Asphalt_withCrack-Only-LightOff.usdz", details: "test"),
        Model(id: 3, name: "4", modelName: "Asphalt_withCrack-All-SphereOnly.usdz", details: "test"),
        Model(id: 4, name: "5", modelName: "Asphalt_withCrack-All-SphereOnly_light.usdz", details: "test"),
        Model(id: 5, name: "6", modelName: "Asphalt_withCrack-All-SphereOnly-Plane.usdz", details: "test"),
        Model(id: 6, name: "7", modelName: "Asphalt_withCrack-All-SphereOnly-Plane_light.usdz", details: "test"),
        Model(id: 7, name: "8", modelName: "Asphalt_withCrack-All-SphereOnly-Plane_4.usdz", details: "test")
    ]
    
    @State var index = 0
    
    var body: some View{
        let scene = SCNScene(named: models[index].modelName)
        scene?.background.contents = UIColor.black
        
        // 모든 조명 노드를 제거
        for node in scene?.rootNode.childNodes ?? [] {
            if node.light != nil {
                node.removeFromParentNode()
            }
        }
        
        return ScrollView {
            VStack{
                SceneView(scene: scene, options: [.autoenablesDefaultLighting,.allowsCameraControl])
                    .frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height)
                
            }
        }
    }
    
}

// Sample Data...

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
