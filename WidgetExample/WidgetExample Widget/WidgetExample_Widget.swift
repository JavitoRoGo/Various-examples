//
//  WidgetExample_Widget.swift
//  WidgetExample Widget
//
//  Created by Javier Rodríguez Gómez on 24/12/22.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), todos: [.placeholder(0), .placeholder(1)])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        Task {
            do {
                let todos = try await TodoService.shared.getAllTodos()
                let fiveTodos = Array(todos.prefix(5))
                let entry = SimpleEntry(date: .now, todos: fiveTodos)
                completion(entry)
            } catch {
                completion(SimpleEntry(date: .now, todos: [.placeholder(0)]))
            }
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        Task {
            do {
                let allTodos = try await TodoService.shared.getAllTodos()
                let fiveTodos = Array(allTodos.prefix(5)) //cogemos los 5 primeros porque si mostramos muchos en el widget se bloquea
                let entry = SimpleEntry(date: .now, todos: fiveTodos)
                
                let timeline = Timeline(entries: [entry], policy: .after(.now.advanced(by: 60*60*30))) //para refrescar después de 30 min
                completion(timeline)
            } catch {
                let entries = [SimpleEntry(date: .now, todos: [.placeholder(0)])]
                let timeline = Timeline(entries: entries, policy: .after(.now.advanced(by: 60*60*30)))
                completion(timeline)
            }
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let todos: [Todo]
}

struct WidgetExample_Widget: Widget {
    let kind: String = "WidgetExample_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetView(entry: entry)
        }
        .supportedFamilies([.systemMedium, .systemLarge, .accessoryInline, .accessoryCircular, .accessoryRectangular])
        .configurationDisplayName("My Todos")
        .description("View your latest todo(s).")
    }
}

