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
        Model(id: 0, name: "Earth", modelName: "head05.scn", details: "test")
    ]

    @State var index = 0

    var body: some View{
        let scene = SCNScene(named: models[index].modelName)
        scene?.background.contents = UIColor.black

        return ScrollView {
            VStack{

                // Going to use SceneKit Scene View....

                // default is first object ie: Earth...

                // Scene View Has a default Camera View...  
                // if you nedd custom means add there...
                SceneView(scene: scene, options: [.autoenablesDefaultLighting,.allowsCameraControl])
                // for user action...
                // setting custom frame...
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
