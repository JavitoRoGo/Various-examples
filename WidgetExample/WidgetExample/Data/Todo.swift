//
//  Todo.swift
//  WidgetExample
//
//  Created by Javier Rodríguez Gómez on 24/12/22.
//

import Foundation

struct Todo: Decodable, Identifiable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}

extension Todo {
    static func placeholder(_ id: Int) -> Todo {
        Todo(userId: 0, id: id, title: "Placeholder", completed: .random())
    }
}
