//
//  ContentView.swift
//  OnBoardingExample
//
//  Created by Javier Rodríguez Gómez on 29/2/24.
//

import SwiftUI

struct ContentView: View {
	@State var viewModel: ContentViewModel
	@State private var showOnboarding = false
	
    var body: some View {
		Text("ContentView")
			.task {
				showOnboarding = viewModel.hasToShowOnboarding()
			}
			.sheet(isPresented: $showOnboarding) {
				OnboardingView(viewModel: OnboardingViewModel(settingsRepository: UserDefaultsSettingsRepository()))
			}
    }
}

#Preview {
    ContentView(viewModel: ContentViewModel(settingsRepository: UserDefaultsSettingsRepository()))
//		.environment(\.locale, .init(identifier: "es"))
}
