//
//  ViewModifiers.swift
//  PasswordCreator
//
//  Created by Javier Rodríguez Gómez on 25/9/23.
//

import SwiftUI

extension View {
	func centerH() -> some View {
		HStack {
			Spacer()
			self
			Spacer()
		}
	}
	
	func addNavigationView(title: String) -> some View {
		NavigationStack {
			self
				.navigationTitle(title)
		}
	}
}
