//
//  ConnectivityManager.swift
//  WatchConnectivityExample
//
//  Created by Javier Rodríguez Gómez on 3/2/23.
//

import Foundation
import WatchConnectivity

struct MessageSent {
    let text: String
}

class ConnectivityManager: NSObject, WCSessionDelegate {
    var wcSession: WCSession! = nil
    var messageSent: MessageSent? = nil
    
    override init() {
        super.init()
        
        if WCSession.isSupported() {
            wcSession = WCSession.default
            wcSession.delegate = self
            wcSession.activate()
            print("WCSession supported")
        } else {
            print("WCSession is NOT supported")
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        wcSession.activate()
    }
    #endif
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        let text = message["message"] as! String
        messageSent = MessageSent(text: text)
    }
}
