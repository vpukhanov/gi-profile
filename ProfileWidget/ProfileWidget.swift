//
//  ProfileWidget.swift
//  ProfileWidget
//
//  Created by Vyacheslav Pukhanov on 14/10/2022.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), profile: Profile(
            character: Character.all[0],
            namecard: Namecard.all[0],
            nickname: "The Alchemist",
            signature: "If one day, I lose control...\nCan I rely on you to stop me?"
        ))
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        getProfile(from: configuration) { profile in
            completion(SimpleEntry(date: Date(), profile: profile))
        }
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getProfile(from: configuration) { profile in
            let entry = SimpleEntry(date: Date(), profile: profile)
            let timeline = Timeline(entries: [entry], policy: .never)
            completion(timeline)
        }
    }
    
    private func getProfile(from configuration: ConfigurationIntent, completion: @escaping (Profile?) -> Void) {
        ProfileStore.load { result in
            switch result {
            case .failure:
                completion(nil)
            case .success(let profiles):
                let profile = profiles.first { $0.id.uuidString == configuration.profile?.identifier }
                completion(profile)
            }
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let profile: Profile?
}

struct ProfileWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        if let profile = entry.profile {
            ProfileView(profile: .constant(profile))
        } else {
            Text("Create a profile in the \"GI Profile\" app and select it in the widget options.")
                .padding()
                .multilineTextAlignment(.center)
        }
    }
}

@main
struct ProfileWidget: Widget {
    let kind: String = "ProfileWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            ProfileWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("GI Profile")
        .description("Displays one of the profiles created in the app.")
        .supportedFamilies([.systemMedium])
    }
}
