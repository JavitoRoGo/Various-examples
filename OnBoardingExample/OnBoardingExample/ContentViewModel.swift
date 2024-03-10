//
//  ContentViewModel.swift
//  OnBoardingExample
//
//  Created by Javier Rodríguez Gómez on 10/3/24.
//

import Foundation

@Observable
final class ContentViewModel {
	private let settingsRepository: SettingsRepository
	
	init(settingsRepository: SettingsRepository) {
		self.settingsRepository = settingsRepository
	}
	
	func hasToShowOnboarding() -> Bool {
		!settingsRepository.hasViewedOnboarding
	}
}
