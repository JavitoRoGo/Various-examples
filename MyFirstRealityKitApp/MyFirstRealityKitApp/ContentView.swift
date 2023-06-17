//
//  ContentView.swift
//  MyFirstRealityKitApp
//
//  Created by Javier Rodríguez Gómez on 17/6/23.
//

import RealityKit
import SwiftUI

struct ContentView: View {
    var body: some View {
        ARViewContainer()
            .edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    // Una vista de AR es una subclase de UIView, que pertenece a UIKit
    // Por eso tenemos que crear un contenedor para usar la vista de UIKit en SwitUI
    func makeUIView(context: Context) -> some ARView {
        let arView = ARView(frame: .zero)
        
        // Load the guitAR scene from the experience reality file
        // También se puede cargar de forma asíncrona para que escenas grandes no congelen la experiencia
        let guitarAnchor = try! Experience.loadGuitar()
        
        // Add the box anchor to the scene
        arView.scene.anchors.append(guitarAnchor)
        
        return arView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) { }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
