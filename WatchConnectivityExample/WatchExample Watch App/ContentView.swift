//
//  ContentView.swift
//  WatchExample Watch App
//
//  Created by Javier Rodríguez Gómez on 3/2/23.
//

import SwiftUI
import WatchConnectivity

struct ContentView: View {
    var text: String {
        wcSession.messageSent?.text ?? "No message sent"
    }
    var wcSession = ConnectivityManager()
    
    var body: some View {
        VStack {
            Text(text)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
