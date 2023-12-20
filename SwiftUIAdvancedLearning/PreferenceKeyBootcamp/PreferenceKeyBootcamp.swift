//
//  PreferenceKeyBootcamp.swift
//  SwiftUIAdvancedLearning
//
//  Created by Berkay Tuncel on 20.12.2023.
//

import SwiftUI

struct PreferenceKeyBootcamp: View {
    
    @State private var text: String = "Hello, world!"
    
    var body: some View {
        NavigationStack {
            VStack {
                SecondaryScreen(text: text)
                    .navigationTitle("Navigation Title")            }
        }
        .onPreferenceChange(CustomTitlePreferenceKey.self, perform: { value in
            self.text = value
        })
    }
}

extension View {
    func customTitle(_ text: String) -> some View {
        preference(key: CustomTitlePreferenceKey.self, value: text)
    }
}

#Preview {
    PreferenceKeyBootcamp()
}

struct SecondaryScreen: View {
    
    let text: String
    @State private var newValue: String = ""
    
    var body: some View {
        Text(text)
            .onAppear(perform: getDataFromDatabase)
            .customTitle(newValue)
    }
    
    private func getDataFromDatabase() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.newValue = "NEW VALUE FROM DATABASE"
        }
    }
}

struct CustomTitlePreferenceKey: PreferenceKey {

    static var defaultValue: String = ""
    
    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
}
