//
//  ContentView.swift
//  WatchConnectivityExampleUI
//
//  Created by Javier Rodríguez Gómez on 3/2/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = MessageListViewModel()
    @State private var isReachable = "NO"
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button("Check") {
                        isReachable = viewModel.session.isReachable ? "YES" : "NO"
                    }
                    .padding(.leading, 16)
                    Spacer()
                    Text("isReachable")
                        .font(.headline)
                        .padding()
                    Text(isReachable)
                        .foregroundColor(.gray)
                        .font(.subheadline)
                        .padding()
                }
                .background(Color.init(.systemGray5))
                List {
                    ForEach(viewModel.messagesData, id: \.self) { animal in
                        MessageRow(animalModel: animal)
                    }
                }
                .listStyle(.plain)
                Spacer()
            }
            .navigationTitle("Receiver")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
