//
//  MainView.swift
//  JournalX
//
//  Created by Karan Oroumchi on 20/11/23.
//

import SwiftUI

struct MainView: View {
    
    @State private var showSheetPresented = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: colorScheme == .dark ? [Color(red: 16/255, green: 17/255, blue: 34/255), Color(red: 88/255, green: 60/255, blue: 101/255)] : [Color.white, Color.white]),
                               startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
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
                        .accessibility(label: Text("Start Journaling"))
                    
                    Text("Create your personal journal.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .accessibility(label: Text("Create your personal journal."))
                    
                    Text("Tap the plus button to get started.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(EdgeInsets(top: 0, leading: 55, bottom: 70, trailing: 55))
                        .accessibility(label: Text("Tap the plus button to get started."))
                    Spacer()
                }
            }
            .navigationTitle("Journal")
            .foregroundColor(Color("TitleColor"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button(action: {
                            // Handle "All Entries" action
                        }) {
                            Label("All Entries", systemImage: "")
                        }
                        .accessibility(label: Text("All Entries"))
                        
                        Button(action: {
                            // Handle "Reflections" action
                        }) {
                            Label("Reflections", systemImage: "")
                        }
                        .accessibility(label: Text("Reflections"))
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease")
                            .resizable()
                            .frame(width: 18, height: 10)
                            .foregroundColor(Color(.systemGray))
                            .padding(10)
                            .background(Circle().foregroundColor(Color(.systemGray5)))
                            .accessibility(label: Text("Menu"))
                        
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        showSheetPresented.toggle()
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
                        .accessibility(label: Text("Add New Entry"))
                        .accessibility(hint: Text("Double tap to add a new entry."))
                    }
                    .padding(.bottom, 10)
                    .sheet(isPresented: $showSheetPresented) {
                        NewEntryView()
                    }
                }
            }
        }
    }
}

#Preview {
    MainView()
}
