//
//  MiniApp86Widget.swift
//  MiniApp86Widget
//
//  Created by 前田航汰 on 2022/08/15.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            configuration: ConfigurationIntent(),
            message: "placeholder"
        )
    }

    // ホーム画面からウィジェットを追加するときの参考ウィジェットに使われるデータ
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(
            date: Date(),
            configuration: configuration,
            message: "snapshot"
        )
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(
                date: entryDate,
                configuration: configuration,
                message: "timeline"
            )
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let message: String
}

struct MiniApp86WidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack{
            Text(entry.date, style: .time)
                .padding()
            Text(entry.message)
        }
    }
}

@main
struct MiniApp86Widget: Widget {
    let kind: String = "MiniApp86Widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            MiniApp86WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct MiniApp86Widget_Previews: PreviewProvider {
    static var previews: some View {
        MiniApp86WidgetEntryView(
            entry:SimpleEntry(
                date: Date(),
                configuration: ConfigurationIntent(),
                message: "preview"
            )
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
