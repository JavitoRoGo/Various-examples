//
//  OnboardingView.swift
//  OnBoardingExample
//
//  Created by Javier Rodríguez Gómez on 29/2/24.
//

import SwiftUI

struct OnboardingView: View {
	@Environment(\.dismiss) var dismiss
	
    var body: some View {
		VStack(spacing: 0) {
			Text("appName")
				.font(.largeTitle)
				.fontWeight(.black)
				.padding(.vertical, 48)
			
			VStack(alignment: .leading, spacing: 32) {
				makeFeatureView(imageSystemName: "figure.mind.and.body", title: "onboarding.title1", description: "onboarding.description1")
				
				makeFeatureView(imageSystemName: "chart.line.uptrend.xyaxis", title: "onboarding.title2", description: "onboarding.description2")
				
				makeFeatureView(imageSystemName: "lock", title: "onboarding.title3", description: "onboarding.description3")
			}
			.padding(.top)
			
			Spacer()
			
			Button {
				dismiss()
			} label: {
				HStack {
					Spacer()
					Text("onboarding.continue")
						.foregroundStyle(.background)
					Spacer()
				}
				.padding()
				.background(.indigo)
				.clipShape(.buttonBorder)
			}
		}
		.padding()
    }
	
	func makeFeatureView(imageSystemName: String, title: LocalizedStringKey, description: LocalizedStringKey) -> some View {
		HStack {
			Image(systemName: imageSystemName)
				.font(.title)
				.foregroundStyle(.indigo)
				.frame(width: 50)
			
			VStack(alignment: .leading) {
				Text(title)
					.font(.headline)
				
				Text(description)
					.foregroundStyle(.secondary)
			}
		}
	}
}

#Preview {
    OnboardingView()
}

#Preview {
	OnboardingView()
		.environment(\.locale, .init(identifier: "es"))
}
