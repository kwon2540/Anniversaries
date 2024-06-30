//
//  Created by マハルジャン ビニシュ on 2024/04/28.
//

import WidgetKit
import SwiftDataClient
import ComposableArchitecture

struct AnniversaryProvider: TimelineProvider {
    
    @Dependency(\.anniversaryDataClient) var anniversaryDataClient
    
    func placeholder(in context: Context) -> AnniversaryEntry {
        return AnniversaryEntry(date: .now, kind: .birth, title: "Birthday", name: "John Appleseed", anniversaryDate: Date(timeIntervalSince1970: 0), isEmpty: false)
    }

    func getSnapshot(in context: Context, completion: @escaping (AnniversaryEntry) -> ()) {
        let placeholderAnniversary = AnniversaryEntry(date: .now, kind: .birth, title: "", name: "John AppleSeed", anniversaryDate: .now + 604800, isEmpty: false)
        completion(placeholderAnniversary)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<AnniversaryEntry>) -> ()) {
        let calendar = Calendar.current
        guard let nextRefreshDate = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: .now)) else {
            fatalError("Failed to calculate the next refresh date.")
        }
        
        let entry = createNearestAnniversaryEntry(refreshDate: nextRefreshDate)
        
        let timeline = Timeline(entries: [entry], policy: .after(nextRefreshDate))
        completion(timeline)
    }
}

// MARK: Database
extension AnniversaryProvider {
    private func createNearestAnniversaryEntry(refreshDate: Date) -> AnniversaryEntry {
        guard let anniversaries = try? anniversaryDataClient.fetch(),
              anniversaries.count > 0,
              let nearestAnniversary = nearestAnniversary(from: anniversaries) else {
            return AnniversaryEntry(date: .now, kind: .birth, title: "", name: "", anniversaryDate: .now, isEmpty: true)
        }
        
        return AnniversaryEntry(date: refreshDate, anniversary: nearestAnniversary)
    }
}

// MARK: Nearest Occurrence
extension AnniversaryProvider {
    // Helper function to get the next occurrence of an anniversary date from today
    private func nextOccurrence(of date: Date) -> Date? {
        let calendar = Calendar.current

        // Extract the month and day components from the anniversary date
        let components = calendar.dateComponents([.month, .day], from: date)
        
        // Create a new date with the current year, and the same month and day
        var nextDateComponents = DateComponents(year: calendar.component(.year, from: .now), month: components.month, day: components.day)
        
        // Check if this year's anniversary date is still in the future
        if let nextDate = calendar.date(from: nextDateComponents), nextDate >= .now {
            return nextDate
        }
        
        // Otherwise, return the anniversary date for the next year
        let nowYear = calendar.component(.year, from: .now)
        nextDateComponents.year = nowYear + 1
        return calendar.date(from: nextDateComponents)
    }
    
    // Function to find the anniversary with the nearest next occurrence date
    private func nearestAnniversary(from anniversaries: [Anniversary]) -> Anniversary? {
        let nextOccurrences = anniversaries.map { ($0, nextOccurrence(of: $0.date) ?? .now) }
        return nextOccurrences.min(by: { $0.1 < $1.1 })?.0
    }
}
