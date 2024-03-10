//
//  Protocol+Ext.swift
//  OnBoardingExample
//
//  Created by Javier Rodríguez Gómez on 10/3/24.
//

import Foundation

protocol SettingsRepository {
	var hasViewedOnboarding: Bool { get set }
}

final class UserDefaultsSettingsRepository: SettingsRepository {
	private let hasViewedOnboardingKey = "hasViewedOnboarding"
	
	var hasViewedOnboarding: Bool {
		get {
			UserDefaults.standard.bool(forKey: hasViewedOnboardingKey)
		}
		set {
			UserDefaults.standard.set(newValue, forKey: hasViewedOnboardingKey)
		}
	}
}
