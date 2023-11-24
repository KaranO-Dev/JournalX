//
//  ReminderStore.swift
//  JournalX
//
//  Created by Karan Oroumchi on 24/11/23.
//

import Foundation

struct Reminder: Identifiable, Codable {
    let id: UUID
    var notes: String
    var isBookmarked: Bool
    var date: Date
}

class ReminderStore: ObservableObject {
    @Published var reminders: [Reminder] = [] {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(reminders) {
                UserDefaults.standard.set(encoded, forKey: "Reminders")
            }
        }
    }

    init() {
        if let reminders = UserDefaults.standard.data(forKey: "Reminders") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Reminder].self, from: reminders) {
                self.reminders = decoded
                return
            }
        }
        self.reminders = []
    }
}


