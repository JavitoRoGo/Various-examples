//
//  PasswordChecking.swift
//  CheckingPasswordDemo
//
//  Created by Javier Rodríguez Gómez on 11/1/23.
//

import Combine
import SwiftUI

class FormViewModel: ObservableObject {
    @Published var password = ""
    @Published var validations: [Validation] = []
    @Published var isValid: Bool = false
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        // Validations
        passwordPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.validations, on: self)
            .store(in: &cancellableSet)
        // isValid
        passwordPublisher
            .receive(on: RunLoop.main)
            .map { validations in
                return validations.filter { validation in
                    return ValidationState.failure == validation.state
                }.isEmpty
            }
            .assign(to: \.isValid, on: self)
            .store(in: &cancellableSet)
    }
    
    private var passwordPublisher: AnyPublisher<[Validation], Never> {
        $password
            .removeDuplicates()
            .map { password in
                var validations: [Validation] = []
                validations.append(Validation(string: password, id: 0, field: .password, validationType: .isNotEmpty))
                validations.append(Validation(string: password, id: 1, field: .password, validationType: .minCharacters(min: 8)))
                validations.append(Validation(string: password, id: 2, field: .password, validationType: .hasSymbols))
                validations.append(Validation(string: password, id: 3, field: .password, validationType: .hasUppercasedLetters))
                return validations
            }.eraseToAnyPublisher()
    }
}

enum Field: String {
    case username
    case password
}

enum ValidationState {
    case success
    case failure
}

enum ValidationType {
    case isNotEmpty
    case minCharacters(min: Int)
    case hasSymbols
    case hasUppercasedLetters
    //case hasNumbers
    
    func fulfills(string: String) -> Bool {
        switch self {
        case .isNotEmpty:
            return !string.isEmpty
        case .minCharacters(min: let min):
            return string.count > min
        case .hasSymbols:
            return string.hasSpecialCharacters()
        case .hasUppercasedLetters:
            return string.hasUppercasedCharacters()
        }
    }
    
    func message(fieldName: String) -> String {
        switch self {
        case .isNotEmpty:
            return "\(fieldName) must not be empty."
        case .minCharacters(min: let min):
            return "\(fieldName) must be longer than \(min) characters."
        case .hasSymbols:
            return "\(fieldName) must have a symbol."
        case .hasUppercasedLetters:
            return "\(fieldName) must have an uppercase letter."
        }
    }
}

struct Validation: Identifiable {
    var id: Int
    var field: Field
    var validationType: ValidationType
    var state: ValidationState
    
    init(string: String, id: Int, field: Field, validationType: ValidationType) {
        self.id = id
        self.field = field
        self.validationType = validationType
        self.state = validationType.fulfills(string: string) ? .success : .failure
    }
}

// Uso de Regex
extension String {
    func hasUppercasedCharacters() -> Bool {
        stringFulFillsRegex(regex: ".*[A-Z]+.*")
        //regex:    .* lo que sea salvo salto de línea
        //          [A-Z]+ uno o más mayúsculas
    }
    func hasSpecialCharacters() -> Bool {
        stringFulFillsRegex(regex: ".*[^A-Za-z0-9].*")
        // regex: [^A-Za-z0-9] lo que sea salvo letras y números
    }
    // para comprobar si tiene números creo que es "[0-9]"
    private func stringFulFillsRegex(regex: String) -> Bool {
        let texttest = NSPredicate(format: "SELF MATCHES %@", regex)
        guard texttest.evaluate(with: self) else {
            return false
        }
        return true
    }
}
