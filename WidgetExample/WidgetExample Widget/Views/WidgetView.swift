//
//  WidgetView.swift
//  WidgetExample WidgetExtension
//
//  Created by Javier Rodríguez Gómez on 24/12/22.
//

import SwiftUI
import WidgetKit

struct WidgetView : View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry // aka SimpleEntry

    var body: some View {
        switch widgetFamily {
        case .systemMedium:
            MediumSizeView(entry: entry)
        case .systemLarge:
            LargeSizeView(entry: entry)
        case .accessoryInline:
            Text(entry.todos.first?.title ?? "No todos")
        case .accessoryCircular:
            Gauge(value: 0.7) {
                Text(entry.date, format: .dateTime.year())
            }
            .gaugeStyle(.accessoryCircular)
        case .accessoryRectangular:
            Gauge(value: 0.7) {
                Text(entry.date, format: .dateTime.year())
            }
            .gaugeStyle(.accessoryLinear)
        default:
            Text("Not implemented!")
        }
    }
}


struct WidgetExample_Widget_Previews: PreviewProvider {
    static var previews: some View {
        WidgetView(entry: SimpleEntry(date: Date(), todos: [.placeholder(0), .placeholder(1)]))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
