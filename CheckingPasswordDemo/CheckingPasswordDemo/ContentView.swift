//
//  ContentView.swift
//  CheckingPasswordDemo
//
//  Created by Javier Rodríguez Gómez on 11/1/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var userViewModel = FormViewModel()
    @State private var isPasswordVisible = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        if isPasswordVisible {
                            TextField("Password", text: $userViewModel.password)
                        } else {
                            SecureField("Password", text: $userViewModel.password)
                        }
                        Spacer().frame(width: 10)
                        Button {
                            isPasswordVisible.toggle()
                        } label: {
                            Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                                .foregroundColor(isPasswordVisible ? .green : .gray)
                                .frame(width: 20, height: 20, alignment: .center)
                        }
                    }
                    
                    List(userViewModel.validations) { validation in
                        HStack {
                            Image(systemName: validation.state == .success ? "checkmark.circle.fill" : "checkmark.circle")
                                .foregroundColor(validation.state == .success ? .green : .gray.opacity(0.3))
                            Text(validation.validationType.message(fieldName: validation.field.rawValue))
                                .strikethrough(validation.state == .success)
                                .font(.caption)
                                .foregroundColor(validation.state == .success ? .gray : .black)
                        }
                        .padding(.leading, 15)
                    }
                } header: {
                    Text("Create your password")
                        .font(.caption)
                }
                
                Section {
                    Button {
                        // Action
                    } label: {
                        HStack {
                            Spacer()
                            Image(systemName: userViewModel.isValid ? "lock.open.fill" : "lock.fill")
                            Text("Create")
                            Spacer()
                        }
                    }
                    .disabled(!userViewModel.isValid)
                }
            }
            .listStyle(.grouped)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
