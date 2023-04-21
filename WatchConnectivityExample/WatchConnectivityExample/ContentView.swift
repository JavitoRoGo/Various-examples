//
//  ContentView.swift
//  WatchConnectivityExample
//
//  Created by Javier Rodríguez Gómez on 3/2/23.
//

import SwiftUI
import WatchConnectivity

struct ContentView: View {
    @State private var text = "texto"
    var wcSession = ConnectivityManager().wcSession
    
    var body: some View {
        VStack(spacing: 50) {
            TextField("Write something", text: $text)
            Button("Send Text") {
                let message = ["message" : text]
                wcSession?.sendMessage(message, replyHandler: nil) { error in
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
