//
//  NewEntryView.swift
//  JournalX
//
//  Created by Karan Oroumchi on 21/11/23.
//

import SwiftUI
import CoreHaptics

struct NewEntryView: View {
    @State var selectedSegment = 0
    @Environment(\.presentationMode) var presentationMode
    @State var questions = ["What was the best part of your day?", "What did you learn today?", "What made you smile today?", "What are you grateful for today?", "What was the most challenging part of your day?", "How did you overcome a challenge today?", "What would you do differently if you could relive the day?", "Who did you interact with today?", "What was something new you noticed today?", "How did you feel today?", "What are you looking forward to tomorrow?"]
    @State var currentQuestionIndices = Array(repeating: 0, count: 3)
    @State private var showModal = false
    @Environment(\.colorScheme) var colorScheme
    @State private var engine: CHHapticEngine?

    init() {
        for i in 0..<currentQuestionIndices.count {
            currentQuestionIndices[i] = Int.random(in: 0..<questions.count)
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    showModal = true
                    giveHapticFeedback()
                }) {
                    HStack {
                        Image(systemName: "square.and.pencil")
                        Text("New Entry")
                    }
                    .foregroundColor(Color.accentColor)
                    .bold()
                    .frame(maxWidth: .infinity, maxHeight: 15)
                    .padding()
                    .background(colorScheme == .dark ? Color(red: 35/255, green: 29/255, blue: 49/255) : Color(red: 230/255, green: 229/255, blue: 247/255))
                    .cornerRadius(10)
                    .accessibility(label: Text("New Entry Button"))
                    .accessibility(hint: Text("Double tap to create a new entry."))
                }
                .padding([.leading, .trailing], 25)
                .padding(.bottom, 20)
                .sheet(isPresented: $showModal) {
                    EntryInputView()
                }

                HStack {
                    Text("Select a Moment and Write")
                        .foregroundColor(Color("TitleColor"))
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                        .padding([.leading, .trailing], 25)

                    Spacer()
                }

                Picker("", selection: $selectedSegment) {
                    Text("Recommended").tag(0)
                    Text("Recent").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding([.leading, .trailing], 25)
                .padding(.bottom, 15)
                .accessibility(label: Text("Segmented Picker"))
                .accessibility(hint: Text("Double tap to switch between Recommended and Recent."))

                ScrollView {
                    if selectedSegment == 0 {
                        // Recommended
                        VStack {
                            ForEach(0..<3) { index in
                                VStack(alignment: .leading) {
                                    Button(action: {
                                        currentQuestionIndices[index] = Int.random(in: 0..<questions.count)
                                        giveHapticFeedback()
                                    }) {
                                        HStack {
                                            Spacer()
                                            Image(systemName: "arrow.triangle.2.circlepath")
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .padding(.leading)
                                    .accessibility(label: Text("Change Question Button"))
                                    .accessibility(hint: Text("Double tap to change the question."))

                                    Text("REFLECTION")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                        .bold()
                                        .padding(.top, -25)

                                    Spacer()

                                    Text(questions[currentQuestionIndices[index]])
                                        .font(.title2)
                                        .bold()
                                        .foregroundColor(.white)
                                        .padding(.bottom, 10)
                                        .accessibility(label: Text("Question: \(questions[currentQuestionIndices[index]])"))
                                }
                                .padding()
                                .frame(height: 160)
                                .background(colors[index % colors.count])
                                .cornerRadius(10)
                                .padding([.leading, .trailing], 25)
                                .padding(.bottom, 15)
                            }
                        }
                    } else {
                        // Recent
                        VStack {

                            Text("No Recent Entry")
                                .bold()
                                .font(.title)

                            Text("Add more journals to see your recent history")
                                .foregroundStyle(Color.gray)
                        }
                        .offset(y: 200)
                    }
                }
            }
            .onAppear {
                for i in 0..<currentQuestionIndices.count {
                    currentQuestionIndices[i] = Int.random(in: 0..<questions.count)
                }
                prepareHapticEngine()
            }
            .background(Color(UIColor.systemGray6))
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                    giveHapticFeedback()
                }.accessibility(label: Text("Cancel Button"))
                    .accessibility(hint: Text("Double tap to dismiss the view.")))
            .navigationBarTitle("", displayMode: .inline)
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

let colors: [Color] = [Color(red: 181/255, green: 73/255, blue: 68/255), Color(red: 111/255, green: 57/255, blue: 86/255), Color(red: 59/255, green: 61/255, blue: 81/255)]

struct NewEntryView_Previews: PreviewProvider {
    static var previews: some View {
        NewEntryView()
    }
}
