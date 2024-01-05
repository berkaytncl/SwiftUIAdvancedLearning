//
//  SubscriptsBootcamp.swift
//  SwiftUIAdvancedLearning
//
//  Created by Berkay Tuncel on 5.01.2024.
//

import SwiftUI

extension Array {
//    func getItem(atIndex: Int) -> Element? {
//        for (index, element) in self.enumerated() {
//            if index == atIndex {
//                return element
//            }
//        }
//        return nil
//    }
//    
//    subscript(atIndex: Double) -> Element? {
//        for (index, element) in self.enumerated() {
//            if Double(index) == atIndex {
//                return element
//            }
//        }
//        return nil
//    }
}

extension Array where Element == String {
    subscript(value: String) -> Element? {
        self.first(where: { $0 == value })
    }
}

struct Address {
    let street: String
    let city: City
}

struct City {
    let name: String
    let state: String
}

struct Customer {
    let name: String
    let address: Address
    
    subscript(value: String) -> String {
        switch value {
        case "name": name
        case "address": "\(address.street), \(address.city.name)"
        case "city": address.city.name
        default: fatalError()
        }
    }
    
    subscript(index: Int) -> String {
        switch index {
        case 0: name
        case 1: "\(address.street), \(address.city.name)"
        default: fatalError()
        }
    }
}

struct SubscriptsBootcamp: View {
    
    @State private var myArray: [String] = ["one", "two", "three"]
    @State private var selectedItem: String? = nil
    
    var body: some View {
        VStack {
            ForEach(myArray, id: \.self) { string in
                Text(string)
            }
            
            Text("SELECTED: \(selectedItem ?? "none")")
        }
        .onAppear {
//            selectedItem = myArray[1.0]
            
            let value = "on"
//            selectedItem = myArray.first(where: { $0 == value })
            selectedItem = myArray[value]
            
            let customer = Customer(
                name: "Nick",
                address: Address(
                    street: "Main Street",
                    city: City(name: "New York", state: "New York"))
            )
//            selectedItem = customer.name
//            selectedItem = customer[keyPath: \.name]
//            selectedItem = customer["address"]
            selectedItem = customer["city"]
//            selectedItem = customer[0]
        }
    }
}

#Preview {
    SubscriptsBootcamp()
}
