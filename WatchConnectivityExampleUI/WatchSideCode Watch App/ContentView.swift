//
//  ContentView.swift
//  WatchSideCode Watch App
//
//  Created by Javier Rodríguez Gómez on 4/2/23.
//

import SwiftUI

struct ContentView: View {
    let animals = ["cat", "dog", "mouse", "dragon", "unicorn"]
    let emojiAnimals = ["🐱", "🐶", "🐹", "🐲", "🦄"]
    
    var viewModel = AnimalListViewModel()
    
    var body: some View {
        List(0..<animals.count) { index in
            Button {
                self.sendMessageData(index: index)
            } label: {
                HStack {
                    Text(emojiAnimals[index])
                        .font(.title)
                        .padding()
                    Text(animals[index])
                }
            }
        }
        .listStyle(.carousel)
        .navigationBarTitle("Animal list")
    }
    
    private func sendMessageData(index: Int) {
        let animal = AnimalModel(name: animals[index], emoji: emojiAnimals[index])
        guard let data = try? JSONEncoder().encode(animal) else { return }
        print("Button tapped ok")
        viewModel.session.sendMessageData(data, replyHandler: nil) { error in
            print(error.localizedDescription)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
