//
//  ViewModifierBootcamp.swift
//  SwiftUIAdvancedLearning
//
//  Created by Berkay Tuncel on 17.12.2023.
//

import SwiftUI

struct DefaultButtonViewModifier: ViewModifier {
    
    let backgroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundStyle(.white)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 10)
    }
}

extension View {
    func withDefaultButtonFormatting(backgroundColor: Color = .red) -> some View {
        modifier(DefaultButtonViewModifier(backgroundColor: backgroundColor))
//        self
//            .modifier(DefaultButtonViewModifier())
    }
}

struct ViewModifierBootcamp: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("Hello, world")
                .font(.headline)
                .withDefaultButtonFormatting()
            
            Text("Hello, world")
                .font(.headline)
                .withDefaultButtonFormatting(backgroundColor: .blue)
            
            Text("Hello, everyone")
                .font(.subheadline)
                .modifier(DefaultButtonViewModifier(backgroundColor: .gray))
        }
        .padding()
    }
}

#Preview {
    ViewModifierBootcamp()
}
