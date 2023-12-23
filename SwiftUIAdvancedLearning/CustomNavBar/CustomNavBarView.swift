//
//  CustomNavBarView.swift
//  SwiftUIAdvancedLearning
//
//  Created by Berkay Tuncel on 23.12.2023.
//

import SwiftUI

struct CustomNavBarView: View {
    
    @Environment(\.dismiss) var dismissScreen
    let showBackButton: Bool
    let title: String
    let subtitle: String?
    
    var body: some View {
        HStack {
            if showBackButton {
                backButton
            }
            Spacer()
            titleSection
            Spacer()
            if showBackButton {
                backButton
                    .opacity(0)
            }
        }
        .padding()
        .tint(.white)
        .foregroundStyle(.white)
        .font(.headline)
        .background(
            Color.blue.ignoresSafeArea(edges: .top)
        )
    }
}

#Preview {
    VStack {
        CustomNavBarView(showBackButton: true, title: "Title", subtitle: "Subtitle")
        Spacer()
    }
}

extension CustomNavBarView {
    private var backButton: some View {
        Button(action: {
            dismissScreen.callAsFunction()
        }, label: {
            Image(systemName: "chevron.left")
        })
    }
    
    private var titleSection: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.title)
                .fontWeight(.semibold)
            if let subtitle {
                Text(subtitle)
            }
        }
    }
}
