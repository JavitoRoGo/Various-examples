//
//  MessageListViewModel.swift
//  WatchConnectivityExampleUI
//
//  Created by Javier Rodríguez Gómez on 4/2/23.
//

import Foundation
import WatchConnectivity

final class MessageListViewModel: NSObject, ObservableObject {
    var session: WCSession
    @Published var messages: [String] = []
    @Published var messagesData: [AnimalModel] = []
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
    }
}

extension MessageListViewModel: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error {
            print(error.localizedDescription)
        } else {
            print("The session has completed activation.")
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) { }
    func sessionDidDeactivate(_ session: WCSession) { }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        DispatchQueue.main.async {
            guard let message = try? JSONDecoder().decode(AnimalModel.self, from: messageData) else { return }
            self.messagesData.append(message)
        }
    }
}
