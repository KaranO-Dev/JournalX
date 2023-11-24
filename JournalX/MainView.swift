//
//  MainView.swift
//  JournalX
//
//  Created by Karan Oroumchi on 20/11/23.
//

import SwiftUI
import CoreHaptics

struct MainView: View {

    @EnvironmentObject var reminderStore: ReminderStore
    @State private var showSheetPresented = false
    @Environment(\.colorScheme) var colorScheme
    @State private var engine: CHHapticEngine?

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMM"
        return formatter
    }

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: colorScheme == .dark ? [Color(red: 16/255, green: 17/255, blue: 34/255), Color(red: 88/255, green: 60/255, blue: 101/255)] : [Color.white, Color.white]),
                               startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)

                if reminderStore.reminders.isEmpty {
                    VStack {
                        Spacer()

                        Image("Image of App")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .shadow(color: (colorScheme == .dark ? Color.white : Color.black).opacity(0.2), radius: 20, x: 0, y: -8)
                            .accessibility(label: Text("App Image"))

                        Text("Start Journaling")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(colorScheme == .dark ? .white : .black)

                        Text("Create your personal journal.")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        Text("Tap the plus button to get started.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(EdgeInsets(top: 0, leading: 55, bottom: 70, trailing: 55))
                        Spacer()
                    }
                } else {
                    ScrollView {
                        ForEach(reminderStore.reminders) { reminder in
                            VStack(alignment: .leading) {
                                Text(reminder.notes)
                                    .font(.headline)
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                                Divider()
                                Text("\(reminder.date, formatter: dateFormatter)")
                                    .font(.subheadline)
                                    .foregroundColor(colorScheme == .dark ? .white : .black)

                                Button(action: {
                                    reminderStore.reminders.removeAll(where: { $0.id == reminder.id })
                                    giveHapticFeedback()
                                }) {
                                    Spacer()

                                    HStack {
                                        Image(systemName: "trash")
                                    }
                                    .padding()
                                    .frame(width: 20, height: 20, alignment: .center)
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                                }
                            }
                            .padding()
                            .background(colorScheme == .dark ? Color.gray : Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding(.horizontal)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Journal")
            .foregroundColor(Color("TitleColor"))
            .onAppear(perform: prepareHapticEngine)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button(action: {
                            // Handle "All Entries" action
                        }) {
                            Label("All Entries", systemImage: "")
                        }

                        Button(action: {
                            // Handle "Reflections" action
                        }) {
                            Label("Reflections", systemImage: "")
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease")
                            .resizable()
                            .frame(width: 18, height: 10)
                            .foregroundColor(Color(.systemGray))
                            .padding(10)
                            .background(Circle().foregroundColor(Color(.systemGray5)))
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        showSheetPresented.toggle()
                        giveHapticFeedback()
                    }) {
                        ZStack {
                            Circle()
                                .foregroundColor(colorScheme == .dark ? Color.accentColor : Color.white)
                                .frame(width: 70, height: 70)
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)

                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .bold()
                                .foregroundColor(colorScheme == .dark ? .white : Color.accentColor)
                        }
                    }
                    .padding(.bottom, 10)
                    .sheet(isPresented: $showSheetPresented) {
                        NewEntryView()
                    }
                }
            }
        }
    }

    func giveHapticFeedback() {
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

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(ReminderStore())
    }
}
