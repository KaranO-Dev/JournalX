//
//  JournalXApp.swift
//  JournalX
//
//  Created by Karan Oroumchi on 15/11/23.
//

import SwiftUI

@main
struct JournalXApp: App {
    let reminderStore = ReminderStore()

    var body: some Scene {
        WindowGroup {
            MainView().environmentObject(reminderStore)
        }
    }
}
