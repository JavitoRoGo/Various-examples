//
//  OnboardingViewModel.swift
//  OnBoardingExample
//
//  Created by Javier Rodríguez Gómez on 10/3/24.
//

import Foundation

@Observable
final class OnboardingViewModel {
	private var settingsRepository: SettingsRepository
	
	init(settingsRepository: SettingsRepository) {
		self.settingsRepository = settingsRepository
	}
	
	func setOnboardingAsViewed() {
		settingsRepository.hasViewedOnboarding = true
	}
}
