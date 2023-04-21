//
//  AnimalListViewModel.swift
//  WatchSide Watch App
//
//  Created by Javier Rodríguez Gómez on 4/2/23.
//

import Foundation
import WatchConnectivity

final class AnimalListViewModel: NSObject {
    var session: WCSession
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
    }
}

extension AnimalListViewModel: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error {
            print(error.localizedDescription)
        } else {
            print("The session has completed activation.")
        }
    }
}
