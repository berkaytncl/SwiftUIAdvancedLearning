//
//  CustomTabBarContainerView.swift
//  SwiftUIAdvancedLearning
//
//  Created by Berkay Tuncel on 21.12.2023.
//

import SwiftUI

struct CustomTabBarContainerView<Content: View>: View {
    
    @Binding var selection: TabBarItem
    let content: Content
    @State private var tabs: [TabBarItem] = []
    
    init(selection: Binding<TabBarItem>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            content.ignoresSafeArea()
            
            CustomTabBarView(tabs: tabs, selection: $selection, localSelection: selection)
        }
        .onPreferenceChange(TabBarItemsPreferenceKey.self, perform: { value in
            tabs = value
        })
    }
}

#Preview {
    
    let tabs: [TabBarItem] = [.home, .favorites, .profile]
    
    return CustomTabBarContainerView(selection: .constant(tabs.first!)) {
        Color.red
    }
}
