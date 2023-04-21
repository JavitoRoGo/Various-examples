//
//  LargeSizeView.swift
//  WidgetExample WidgetExtension
//
//  Created by Javier Rodríguez Gómez on 25/12/22.
//

import SwiftUI
import WidgetKit

struct LargeSizeView: View {
    var entry: SimpleEntry
    
    var body: some View {
        VStack {
                HStack(spacing: 16) {
                    Text("My Todos")
                    Text(Date.now, format: .dateTime)
                    Spacer()
                }
                .padding(8)
                .background(.blue)
                .foregroundColor(.white)
                .clipped()
                .shadow(radius: 5)
            
            ForEach(entry.todos) { todo in
                Link(destination: URL(string: "myapp://todo/\(todo.id)")!) {
                    HStack {
                        Circle()
                            .stroke(lineWidth: 2)
                            .frame(width: 30, height: 30)
                            .overlay {
                                if todo.completed {
                                    Image(systemName: "checkmark")
                                }
                            }
                        Text(todo.title)
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                Divider()
            }
            Spacer()
        }
    }
}
