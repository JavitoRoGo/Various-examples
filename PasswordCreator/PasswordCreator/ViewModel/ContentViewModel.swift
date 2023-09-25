//
//  ContentViewModel.swift
//  PasswordCreator
//
//  Created by Javier Rodríguez Gómez on 25/9/23.
//

import SwiftUI

extension ContentView {
	final class ViewModel: ObservableObject {
		@Published var passwords: [Password] = []
		@Published var containsSymbols = true
		@Published var containsUppercase = false
		@Published var length = 10
		
		init() {
			createPassword()
		}
		
		func createPassword() {
			let alphabet = "abcdefghijklmnopqrstuvwxyz"
			var base = alphabet + "1234567890"
			var newPassword = ""
			
			if containsSymbols {
				base += "!$%&/()=?;:_*,.-"
			}
			if containsUppercase {
				base += alphabet.uppercased()
			}
			
			for _ in 0..<length {
				let randChar = base.randomElement()!
				newPassword += String(randChar)
				// realmente así no aseguras tener un símbolo o mayúscula ¿no?
				// se podría mejorar añadiendo unas comprobaciones
			}
			if containsSymbols && !NSPredicate(format: "SELF MATCHES %@", ".*[^A-Za-z0-9]+.*").evaluate(with: newPassword) { createPassword() }
			if containsUppercase && !NSPredicate(format: "SELF MATCHES %@", ".*[A-Z]+.*").evaluate(with: newPassword) { createPassword() }
			
			let password = Password(password: newPassword, containsSymbols: containsSymbols, containsUppercase: containsUppercase)
			
			withAnimation {
				passwords.insert(password, at: 0)
			}
		}
	}
}
