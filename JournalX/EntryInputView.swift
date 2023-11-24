//
//  EntryInputView.swift
//  JournalX
//
//  Created by Karan Oroumchi on 21/11/23.
//

import SwiftUI
import CoreHaptics

struct EntryInputView: View {
    
    @State private var reminderNotes = "Start Writing..."
    @State private var isBookmarked = false
    @State private var showDatePicker = false
    @State private var selectedDate = Date()
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var reminderStore: ReminderStore
    @State private var engine: CHHapticEngine?
    
    
    var today: String {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd MMM"
        return formatter.string(from: today)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                TextEditor(text: $reminderNotes)
                    .foregroundColor(reminderNotes == "Start Writing..." ? .gray : .white)
                    .onTapGesture {
                        if reminderNotes == "Start Writing..." {
                            reminderNotes = ""
                        }
                        giveHapticFeedback()
                    }
                    .accessibility(label: Text("Text Editor"))
                    .accessibility(hint: Text("Double tap to start writing."))
                
                if showDatePicker {
                    
                    VStack {
                        DatePicker("Select a date", selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .frame(maxHeight: 350)
                            .padding()
                            .background(Color(.systemGray5))
                            .cornerRadius(15)
                            .shadow(radius: 5)
                            .accessibility(label: Text("Date Picker"))
                            .accessibility(hint: Text("Adjust the date by swiping up or down."))
                        
                        Button("Done") {
                            withAnimation {
                                showDatePicker = false
                                giveHapticFeedback(strength: .hapticIntensity)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray5))
                        .foregroundColor(.indigo)
                        .cornerRadius(10)
                        .bold()
                        .accessibility(label: Text("Done Button"))
                        .accessibility(hint: Text("Double tap to close the date picker."))
                        
                        Button("Cancel") {
                            withAnimation {
                                showDatePicker = false
                                giveHapticFeedback()
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray5))
                        .foregroundColor(.indigo)
                        .cornerRadius(10)
                        .bold()
                        .accessibility(label: Text("Cancel Button"))
                        .accessibility(hint: Text("Double tap to close the date picker without saving changes."))
                    }
                    .transition(.move(edge: .bottom))
                    .offset(y: 20)
                }
            }
            .navigationBarItems(
                leading: Button(action: {
                    isBookmarked.toggle()
                    giveHapticFeedback()
                }) {
                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                        .foregroundColor(isBookmarked ? .red : .accentColor)
                }.accessibility(label: Text(isBookmarked ? "Remove Bookmark" : "Add Bookmark"))
                    .accessibility(hint: Text("Double tap to toggle bookmark.")),
                trailing: Button("Done") {
                    let reminder = Reminder(id: UUID(), notes: reminderNotes, isBookmarked: isBookmarked, date: selectedDate)
                    reminderStore.reminders.append(reminder)
                    presentationMode.wrappedValue.dismiss()
                    giveHapticFeedback(strength: .hapticIntensity)
                }
                    .accessibility(label: Text("Done Button"))
                    .accessibility(hint: Text("Double tap to dismiss the view."))
            )
            .navigationBarTitle(Text(today), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            // Handle Entry date action
                            giveHapticFeedback()
                        }) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                VStack(alignment: .leading) {
                                    Text("Entry date")
                                    Text(today)
                                        .font(.caption)
                                }
                            }
                        }.accessibility(label: Text("Entry Date"))
                            .accessibility(hint: Text("Double tap to select entry date."))
                        
                        Button(action: {
                            print("Custom date button tapped")
                            withAnimation {
                                showDatePicker.toggle()
                                giveHapticFeedback()
                            }
                        }) {
                            Label("Custom date", systemImage: "calendar")
                        }.accessibility(label: Text("Custom Date"))
                            .accessibility(hint: Text("Double tap to select a custom date."))
                        
                        Button(action: {
                            // Handle Delete action
                            giveHapticFeedback()
                        }) {
                            Label("Delete", systemImage: "trash")
                                .foregroundColor(.red) // Make the Delete button red
                        }.accessibility(label: Text("Delete"))
                            .accessibility(hint: Text("Double tap to delete."))
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.accentColor)
                            .onTapGesture {
                                // Add haptic feedback for ellipsis button
                                giveHapticFeedback()
                            }
                    }.accessibility(label: Text("Menu"))
                        .accessibility(hint: Text("Double tap to open menu."))
                }
            }
            .overlay(
                VStack {
                    Spacer()
                    TabView {
                        Button(action: {
                            // Handle magic icon action
                            giveHapticFeedback()
                        }) {
                            EmptyView()
                        }
                        .tabItem {
                            Image(systemName: "wand.and.stars")
                        }.accessibility(label: Text("Magic Icon"))
                            .accessibility(hint: Text("Double tap to activate magic icon."))
                        
                        Button(action: {
                            // Open Image Picker
                            giveHapticFeedback()
                        }) {
                            EmptyView()
                        }
                        .tabItem {
                            Image(systemName: "photo")
                        }.accessibility(label: Text("Image Picker"))
                            .accessibility(hint: Text("Double tap to open image picker."))
                        
                        Button(action: {
                            // Open Camera
                            giveHapticFeedback()
                        }) {
                            EmptyView()
                        }
                        .tabItem {
                            Image(systemName: "camera")
                        }.accessibility(label: Text("Camera"))
                            .accessibility(hint: Text("Double tap to open camera."))
                        
                        Button(action: {
                            // Open Voice Recorder
                            giveHapticFeedback()
                        }) {
                            EmptyView()
                        }
                        .tabItem {
                            Image(systemName: "mic")
                        }.accessibility(label: Text("Voice Recorder"))
                            .accessibility(hint: Text("Double tap to open voice recorder."))
                        
                        Button(action: {
                            // Open Recent Locations
                            giveHapticFeedback()
                        }) {
                            EmptyView()
                        }
                        .tabItem {
                            Image(systemName: "location")
                        }.accessibility(label: Text("Recent Locations"))
                            .accessibility(hint: Text("Double tap to open recent locations."))
                    }
                    .frame(height: 50)
                }
                
            )
        }
        .onAppear {
            prepareHapticEngine()
        }
    }
    
    func giveHapticFeedback(strength: CHHapticEvent.ParameterID = .hapticIntensity) {
        do {
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: 0)
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Haptic feedback failed: \(error.localizedDescription)")
        }
    }
    
    func prepareHapticEngine() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Haptic engine failed to start: \(error.localizedDescription)")
        }
    }
}


struct EntryInputView_Previews: PreviewProvider {
    static var previews: some View {
        EntryInputView().environmentObject(ReminderStore())
    }
}
