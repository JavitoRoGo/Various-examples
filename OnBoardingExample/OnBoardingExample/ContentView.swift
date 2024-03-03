//
//  ContentView.swift
//  OnBoardingExample
//
//  Created by Javier Rodríguez Gómez on 29/2/24.
//

import SwiftUI

struct ContentView: View {
	@State private var showOnboarding = false
	
    var body: some View {
		Button("contentView.showOnboarding") {
			showOnboarding = true
		}
		.sheet(isPresented: $showOnboarding) {
			OnboardingView()
		}
    }
}

#Preview {
    ContentView()
//		.environment(\.locale, .init(identifier: "es"))
}
