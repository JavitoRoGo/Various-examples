//
//  HealthKitExampleApp.swift
//  HealthKitExample
//
//  Created by Javier Rodríguez Gómez on 23/8/23.
//

import SwiftUI

@main
struct HealthKitExampleApp: App {
	@StateObject var manager = HealthManger()
	
    var body: some Scene {
        WindowGroup {
            BeActiveTabView()
				.environmentObject(manager)
        }
    }
}
