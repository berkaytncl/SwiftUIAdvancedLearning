//
//  AppNavBarView.swift
//  SwiftUIAdvancedLearning
//
//  Created by Berkay Tuncel on 23.12.2023.
//

import SwiftUI

struct AppNavBarView: View {
    var body: some View {
        CustomNavView {
            ZStack {
                Color.orange.ignoresSafeArea()
                CustomNavLink(destination:
                    Text("Destination")
                        .customNavigationTitle("Second Screen")
                        .customNavigationSubitle("Subtitle should be showing!"),
                label: {
                    Text("Navigate")
                })
            }
//            .customNavigationTitle("Custom Title!")
//            .customNavigationBarBackButtonHidden(true)
            .customNavBarItems(title: "New Title!", subtitle: "Subtitle", backButtonHidden: true)
        }
    }
}

#Preview {
    AppNavBarView()
}

extension AppNavBarView {
    private var defaultNavView: some View {
        NavigationStack {
            ZStack {
                Color.green.ignoresSafeArea()
                
                NavigationLink {
                    Text("Destination")
                        .navigationTitle("Title 2")
                        .navigationBarBackButtonHidden()
                } label: {
                    Text("Navigate")
                }
            }
            .navigationTitle("Nav title here")
        }

    }
}
