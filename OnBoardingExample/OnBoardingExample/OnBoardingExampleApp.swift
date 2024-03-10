//
//  OnBoardingExampleApp.swift
//  OnBoardingExample
//
//  Created by Javier Rodríguez Gómez on 29/2/24.
//

import SwiftUI

@main
struct OnBoardingExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ContentViewModel(settingsRepository: UserDefaultsSettingsRepository()))
        }
    }
}
