//
//  CustomOperatorBootcamp.swift
//  SwiftUIAdvancedLearning
//
//  Created by Berkay Tuncel on 5.01.2024.
//

import SwiftUI

struct CustomOperatorBootcamp: View {
    
    @State private var value: Double = 0
    
    var body: some View {
        Text("\(value)")
            .onAppear {
//                value = 5 + 5
//                value = 5 / 2
//                value = (5 + 5) / 2
//                value = 1 +/ 5
//                value = 4 ++/ 5
//                value = 5 ^^^ 10
                
                let someValue: Int = 5
//                value = Double(someValue)
                value = someValue => Double.self
            }
    }
}

infix operator +/
infix operator ++/
infix operator ^^^
infix operator =>

extension FloatingPoint {
    static func +/ (lhs: Self, rhs: Self) -> Self {
        (lhs + rhs) / 2
    }
    
    static func ++/ (lhs: Self, rhs: Self) -> Self {
        (lhs + lhs) / rhs
    }
    
    static func ^^^ (lhs: Self, rhs: Self) -> Self {
        maximum(lhs, rhs)
    }
}

protocol InitFromBinaryFloating {
    init<Source>(_ value: Source) where Source : BinaryInteger
}

extension Double: InitFromBinaryFloating {
    
}

extension BinaryInteger {
    static func => <T: InitFromBinaryFloating>(value: Self, newType: T.Type) -> T {
        T(value)
    }
}

#Preview {
    CustomOperatorBootcamp()
}
