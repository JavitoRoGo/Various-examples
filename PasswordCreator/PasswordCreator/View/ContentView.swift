//
//  ContentView.swift
//  PasswordCreator
//
//  Created by Javier Rodríguez Gómez on 25/9/23.
//

import SwiftUI

struct ContentView: View {
	@StateObject private var vm = ViewModel()
	
    var body: some View {
		Form {
			Section("Options") {
				Toggle("Symbols", isOn: $vm.containsSymbols)
				Toggle("Uppercase", isOn: $vm.containsUppercase)
				Stepper("Character count: \(vm.length)", value: $vm.length, in: 6...18)
				Button("Generate password", action: vm.createPassword)
					.centerH()
			}
			
			Section("Passwords") {
				List(vm.passwords) { password in
					HStack {
						Text(password.password)
							.padding()
							.textSelection(.enabled)
						Spacer()
						Image(systemName: "lock.fill")
							.foregroundStyle(password.strengthColor)
					}
				}
			}
		}
		.addNavigationView(title: "iPassword")
    }
}

#Preview {
    ContentView()
}
