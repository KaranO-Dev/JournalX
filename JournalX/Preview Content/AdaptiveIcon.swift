//
//  AdaptiveIcon.swift
//  JournalX
//
//  Created by Karan Oroumchi on 16/11/23.
//

import SwiftUI

struct AdaptiveIcon: View {
    
    var color: Color = .white
    
    var today: String {
        
        let today: Date = .now
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        
        return formatter.string(from: today)
    }
    
    var body: some View {
        
        ZStack{
            Circle()
                .foregroundColor(color)
                .frame(width: 50, height: 50)
            
            
            Image(systemName: "calendar")
                .foregroundColor(.black)
                .font(.title)
            
                .overlay{
                    RoundedRectangle(cornerRadius: 3)
                        .foregroundColor(color)
                        .scaleEffect(CGSize(width: 0.5, height: 0.5))
                        .offset(y: 2)
                }
                .overlay{
                    Text(today)
                        .foregroundStyle(.black)
                        .fontDesign(.rounded)
                        .font(.caption)
                        .bold()
                        .offset(y: 2)
                }
        }
    }
}

#Preview {
    AdaptiveIcon()
}
