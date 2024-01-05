//
//  PropertyWrapper2Bootcamp.swift
//  SwiftUIAdvancedLearning
//
//  Created by Berkay Tuncel on 4.01.2024.
//

import SwiftUI
import Combine

@propertyWrapper
struct Capitalized: DynamicProperty {
    @State private var value: String
    
    var wrappedValue: String {
        get {
            value
        }
        nonmutating set {
            value = newValue.capitalized
        }
    }
    
    init(wrappedValue: String) {
        self.value = wrappedValue.capitalized
    }
}

@propertyWrapper
struct Uppercased: DynamicProperty {
    @State private var value: String
    
    var wrappedValue: String {
        get {
            value
        }
        nonmutating set {
            value = newValue.uppercased()
        }
    }
    
    init(wrappedValue: String) {
        self.value = wrappedValue.uppercased()
    }
}

@propertyWrapper
struct FileManagerCodableProperty<T: Codable>: DynamicProperty {
    @State private var value: T?
    private let key: String
    
    var wrappedValue: T? {
        get {
            value
        }
        nonmutating set {
            save(newValue: newValue)
        }
    }
    
    var projectedValue: Binding<T?> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }
    
    init(_ key: String) {
        self.key = key
        
        do {
            let url = FileManager.documentsPath(key: key)
            let data = try Data(contentsOf: url)
            let object = try JSONDecoder().decode(T.self, from: data)
            _value = State(wrappedValue: object)
            print("Success read")
        } catch {
            _value = State(wrappedValue: nil)
            print("Error saving: \(error.localizedDescription)")
        }
    }
    
    init(_ key: KeyPath<FileManagerValues, FileManagerKeypath<T>>) {
        let keypath = FileManagerValues.shared[keyPath: key]
        self.key = keypath.key
        
        do {
            let url = FileManager.documentsPath(key: self.key)
            let data = try Data(contentsOf: url)
            let object = try JSONDecoder().decode(T.self, from: data)
            _value = State(wrappedValue: object)
            print("Success read")
        } catch {
            _value = State(wrappedValue: nil)
            print("Error saving: \(error.localizedDescription)")
        }
    }
    
    private func save(newValue: T?) {
        do {
            let data = try JSONEncoder().encode(newValue)
            try data.write(to: FileManager.documentsPath(key: key))
            value = newValue
            print("Success saved")
        } catch {
            print("Error saving: \(error.localizedDescription)")
        }
    }
}

@propertyWrapper
struct FileManagerCodableStreamableProperty<T: Codable>: DynamicProperty {
    @State private var value: T?
    private let key: String
    private let publisher: CurrentValueSubject<T?, Never>
    
    var wrappedValue: T? {
        get {
            value
        }
        nonmutating set {
            save(newValue: newValue)
        }
    }
    
    var projectedValue: CustomProjectedValue<T> {
        CustomProjectedValue(
            binding: Binding(
                get: { wrappedValue },
                set: { wrappedValue = $0 }
            ),
            publisher: publisher
        )
    }
    
//    var projectedValue: CurrentValueSubject<T?, Never> {
//        publisher
//    }
    
//    var projectedValue: Binding<T?> {
//        Binding(
//            get: { wrappedValue },
//            set: { wrappedValue = $0 }
//        )
//    }
    
    init(_ key: String) {
        self.key = key

        do {
            let url = FileManager.documentsPath(key: key)
            let data = try Data(contentsOf: url)
            let object = try JSONDecoder().decode(T.self, from: data)
            _value = State(wrappedValue: object)
            publisher = CurrentValueSubject(object)
            print("Success read")
        } catch {
            _value = State(wrappedValue: nil)
            publisher = CurrentValueSubject(nil)
            print("Error saving: \(error.localizedDescription)")
        }
    }
    
    init(_ key: KeyPath<FileManagerValues, FileManagerKeypath<T>>) {
        let keypath = FileManagerValues.shared[keyPath: key]
        self.key = keypath.key
        
        do {
            let url = FileManager.documentsPath(key: self.key)
            let data = try Data(contentsOf: url)
            let object = try JSONDecoder().decode(T.self, from: data)
            _value = State(wrappedValue: object)
            publisher = CurrentValueSubject(object)
            print("Success read")
        } catch {
            _value = State(wrappedValue: nil)
            publisher = CurrentValueSubject(nil)
            print("Error saving: \(error.localizedDescription)")
        }
    }
    
    private func save(newValue: T?) {
        do {
            let data = try JSONEncoder().encode(newValue)
            try data.write(to: FileManager.documentsPath(key: key))
            value = newValue
            publisher.send(newValue)
            print("Success saved")
        } catch {
            print("Error saving: \(error.localizedDescription)")
        }
    }
}

struct User: Codable {
    let name: String
    let age: Int
    let isPremium: Bool
}

//enum FileManagerKeys: String {
//    case userProfile
//}

struct FileManagerKeypath<T: Codable> {
    let key: String
    let type: T.Type
}

struct FileManagerValues {
    static let shared = FileManagerValues()
    private init() {}
    
    let userProfile = FileManagerKeypath(key: "user_profile", type: User.self)
}

struct CustomProjectedValue<T: Codable> {
    let binding: Binding<T?>
    let publisher: CurrentValueSubject<T?, Never>
    
    var stream: AsyncPublisher<CurrentValueSubject<T?, Never>> {
        publisher.values
    }
}

struct PropertyWrapper2Bootcamp: View {
    
//    @Capitalized private var title: String = "Hello, world!"
//    @Uppercased private var title: String = "Hello, world!"
//    @FileManagerCodableProperty("user_profile") private var userProfile: User?
//    @FileManagerCodableProperty(FileManagerKeys.userProfile.rawValue) private var userProfile: User?
//    @FileManagerCodableProperty(\.userProfile) private var userProfile: User?
//    @FileManagerCodableProperty(\.userProfile) private var userProfile
    @FileManagerCodableStreamableProperty(\.userProfile) private var userProfile
    
    var body: some View {
        VStack(spacing: 40) {
//            Button(title) {
//                title = "new title"
//            }
            
            SomeBindingView(userProfile: $userProfile.binding)
            
//            Button(userProfile?.name ?? "no value") {
//                userProfile = User(name: "RICKY", age: 111, isPremium: true)
//            }
        }
        .onReceive($userProfile.publisher, perform: { newValue in
            print("RECIEVED NEW VALUE OF: \(newValue)")
        })
        .task {
            for await newValue in $userProfile.stream {
                print("STREAM NEW VALUE OF: \(newValue)")
            }
        }
        .onAppear {
            print(NSHomeDirectory())
        }
    }
}

struct SomeBindingView: View {
    
    @Binding var userProfile: User?
    
    var body: some View {
        Button(userProfile?.name ?? "no value") {
            userProfile = User(name: "Emily", age: 123, isPremium: true)
        }
    }
}

#Preview {
    PropertyWrapper2Bootcamp()
}
