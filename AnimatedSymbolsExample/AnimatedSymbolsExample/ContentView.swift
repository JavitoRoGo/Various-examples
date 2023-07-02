//
//  ContentView.swift
//  AnimatedSymbolsExample
//
//  Created by Javier Rodríguez Gómez on 2/7/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showingEffect = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Label("Bounce", systemImage: "rainbow")
                    .symbolEffect(.bounce, options: .repeat(2), value: showingEffect)
                Label("Pulse", systemImage: "rainbow")
                    .symbolEffect(.pulse, options: .repeating, value: showingEffect)
                Label("Variable color", systemImage: "rainbow")
                    .symbolEffect(.variableColor.iterative.hideInactiveLayers.reversing, value: showingEffect)
                Label("Scale", systemImage: "rainbow")
                    .symbolEffect(.scale.up, isActive: showingEffect)
                Label("Transition", systemImage: showingEffect ? "sun.max" : "moon")
                    .contentTransition(.symbolEffect(.replace.downUp))
                Label("Appear", systemImage: "rainbow")
                    .symbolEffect(.appear, isActive: !showingEffect)
                Label("Disappear", systemImage: "rainbow")
                    .symbolEffect(.disappear, isActive: showingEffect)
                Button("Animate!") {
                    showingEffect.toggle()
                }
            }
            .font(.largeTitle)
            .symbolRenderingMode(.multicolor)
            .padding()
            .toolbar {
                Image(systemName: "wifi")
                    .symbolEffect(.variableColor.iterative.reversing)
            }
        }
    }
}

#Preview {
    ContentView()
}
