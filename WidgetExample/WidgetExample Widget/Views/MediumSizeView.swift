//
//  MediumSizeView.swift
//  WidgetExample WidgetExtension
//
//  Created by Javier Rodríguez Gómez on 25/12/22.
//

import SwiftUI
import WidgetKit

struct MediumSizeView: View {
    var entry: SimpleEntry
    
    var body: some View {
        GroupBox {
            HStack {
                Image(systemName: "person")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.secondary)
                
                Divider()
                
                if let todo = entry.todos.first {
                    VStack(alignment: .leading) {
                        Text(todo.title)
                            .font(.headline)
                        Text(todo.completed ? "Completed" : "Open")
                            .font(.subheadline)
                    }
                } else {
                    Text("Could't load. Try again later")
                }
                
                Spacer()
            }
            .padding()
        } label: {
            Label("My Todos", systemImage: "list.dash")
        }
        .widgetURL(URL(string: "myapp://todo/\(entry.todos.first?.id ?? 0)")) //modificador para abrir una parte específica de la app desde el widget
    }
}
