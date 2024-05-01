//
//  ContentView.swift
//  CustomEnvironmentValues
//
//  Created by Javier Rodríguez Gómez on 1/5/24.
//

import SwiftUI

struct PasswordField: View {
	@Environment(\.isSensitive) private var isSensitive
	
	var body: some View {
		HStack {
			Text("Password")
			Text("12345")
				.redacted(reason: isSensitive ? .placeholder : [])
		}
	}
}

struct ContentView: View {
	@State private var isSensitive = false
	
    var body: some View {
        VStack {
			Toggle("Sensitive", isOn: $isSensitive)
			PasswordField()
				.isSensitive(isSensitive)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}


// 1. Declare a new key with a default value
struct SensitiveKey: EnvironmentKey {
	static let defaultValue: Bool = false
}

// 2. Introduce new value to EnvironmentValues
extension EnvironmentValues {
	var isSensitive: Bool {
		get { self[SensitiveKey.self] }
		set { self[SensitiveKey.self] = newValue }
	}
}

// At this point, the use of this value is: .environment(\.isSensitive, true)
// But it can be done easier
// 3. Add a dedicated modifier
extension View {
	func isSensitive(_ value: Bool) -> some View {
		environment(\.isSensitive, value)
	}
}

// Now it's use is easier: .isSensitive(true)
