//
//  TodoService.swift
//  WidgetExample
//
//  Created by Javier Rodríguez Gómez on 24/12/22.
//

import Foundation

final class TodoService {
    static let shared = TodoService()
    
    private let baseURL: String = "https://jsonplaceholder.typicode.com/"
    
    // A generic helper function to fetch some Decodable T from a given URL
    private func fetch<T: Decodable>(from endpoint: String) async throws -> T {
        let urlString = baseURL + endpoint
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        // The second return value is a URLResponse, that you can use to check the server's response to your request.
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(T.self, from: data)
        
        return result
    }
    
    func getAllTodos() async throws -> [Todo] {
        let todos: [Todo] = try await fetch(from: "todos/")
        return todos
    }
    
    func getTodo(with id: Int) async throws -> Todo {
        let todo: Todo = try await fetch(from: "todos/\(id)")
        return todo
    }
}
