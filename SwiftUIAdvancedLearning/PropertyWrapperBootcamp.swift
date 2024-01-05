//
//  PropertyWrapperBootcamp.swift
//  SwiftUIAdvancedLearning
//
//  Created by Berkay Tuncel on 3.01.2024.
//

import SwiftUI

extension FileManager {
    static func documentsPath(key: String) -> URL {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appending(path: "\(key).txt")
    }
}

@propertyWrapper
struct FileManagerProperty: DynamicProperty {
    @State private var title: String
    private let key: String
    
    var wrappedValue: String {
        get {
            title
        }
        nonmutating set {
            save(newValue: newValue)
        }
    }
    
    var projectedValue: Binding<String> {
        Binding {
            wrappedValue
        } set: { newValue in
            wrappedValue = newValue
        }

    }
    
    init(wrappedValue: String, _ key: String) {
        self.key = key
        
        do {
            title = try String(contentsOf: FileManager.documentsPath(key: key), encoding: .utf8)
            print("Success read")
        } catch {
            title = wrappedValue
            print("Error saving: \(error.localizedDescription)")
        }
    }
    
    private func save(newValue: String) {
        do {
            // When atomically is set to true, it means that the data will be written to a temporary file first.
            // When atomically is set to false, the data is written directly to the specified dile path.
            try newValue.write(to: FileManager.documentsPath(key: key), atomically: false, encoding: .utf8)
            title = newValue
//            print(NSHomeDirectory())
            print("Success saved")
        } catch {
            print("Error saving: \(error.localizedDescription)")
        }
    }
}

struct PropertyWrapperBootcamp: View {
    
    @FileManagerProperty("custom_title") private var title: String = "Starting text"
    @FileManagerProperty("custom_title2") private var title2: String = "Starting text2"
    @FileManagerProperty("custom_title3") private var title3: String = "Starting text3"
//    @AppStorage("title_key") private var title3: String
//    var fileManagerProperty = FileManagerProperty()
//    @State private var title: String = "Starting title"
    @State private var subtitle: String = "SUBTITLE"
    
    var body: some View {
        VStack(spacing: 40) {
            Text(title).font(.largeTitle)
            Text(title2).font(.largeTitle)
            Text(title3).font(.largeTitle)
//            PropertyWrapperChildView(subtitle: $subtitle)
            PropertyWrapperChildView(subtitle: $title)
            
            Button("Click me 1") {
                title = "title 1"
                title2 = "title 2"
            }
            
            Button("Click me 2") {
                title = "title 3"
                title2 = "title 4"
            }
        }
    }
}

struct PropertyWrapperChildView: View {
    
    @Binding var subtitle: String
    
    var body: some View {
        Button {
            subtitle = "ANOTHER TITLE!!"
        } label: {
            Text(subtitle).font(.largeTitle)
        }
    }
}

#Preview {
    PropertyWrapperBootcamp()
}
