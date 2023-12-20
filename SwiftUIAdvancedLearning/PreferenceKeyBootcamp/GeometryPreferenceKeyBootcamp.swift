//
//  GeometryPreferenceKeyBootcamp.swift
//  SwiftUIAdvancedLearning
//
//  Created by Berkay Tuncel on 20.12.2023.
//

import SwiftUI

struct GeometryPreferenceKeyBootcamp: View {
    
    @State private var rectSize: CGSize = .zero
    
    var body: some View {
        VStack {
            Text(rectSize.width.description)
                .frame(width: rectSize.width, height: rectSize.height)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Spacer()
            
            HStack {
                Rectangle()
                
                GeometryReader(content: { geometry in
                    Rectangle()
                        .updateRectangleGeoSize(geometry.size)
                })
                
                Rectangle()
            }
            .frame(height: 55)
        }
        .onPreferenceChange(RectangleGeometryPreferenceKey.self, perform: { value in
            rectSize = value
        })
    }
}

#Preview {
    GeometryPreferenceKeyBootcamp()
}

extension View {
    func updateRectangleGeoSize(_ size: CGSize) -> some View {
        preference(key: RectangleGeometryPreferenceKey.self, value: size)
    }
}

struct RectangleGeometryPreferenceKey: PreferenceKey {
    
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
