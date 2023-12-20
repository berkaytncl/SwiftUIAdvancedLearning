//
//  ScrollViewOffsetPreferenceKeyBootcamp.swift
//  SwiftUIAdvancedLearning
//
//  Created by Berkay Tuncel on 20.12.2023.
//

import SwiftUI

struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View {
    func onScrollViewOffsetChanged(action: @escaping (_ offset: CGFloat) -> ()) -> some View {
        self
            .background(
                GeometryReader(content: { geometry in
                    Text("")
                        .preference(key: ScrollViewOffsetPreferenceKey.self, value: geometry.frame(in: .global).minY)
                })
            )
            .onPreferenceChange(ScrollViewOffsetPreferenceKey.self, perform: { value in
                action(value)
            })
    }
}

struct ScrollViewOffsetPreferenceKeyBootcamp: View {
    
    let title: String = "New title here!!"
    @State private var scrollViewOffset: CGFloat = 0
    
    var body: some View {
        ScrollView {
            VStack {
                titleLayer
                    .opacity(Double(scrollViewOffset) / 75)
                    .onScrollViewOffsetChanged { offset in
                        scrollViewOffset = offset
                    }
                
                contentLayer
            }
            .padding()
        }
        .scrollIndicators(.hidden)
        .overlay(
            navBarLayer.opacity(scrollViewOffset < 30 ? 1 : 0),
            alignment: .top
        )
    }
}

#Preview {
    ScrollViewOffsetPreferenceKeyBootcamp()
}

extension ScrollViewOffsetPreferenceKeyBootcamp {
    private var titleLayer: some View {
        Text(title)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var contentLayer: some View {
        ForEach(0 ..< 30) { _ in
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.red.opacity(0.3))
                .frame(width: 300, height: 200)
        }
    }
    
    private var navBarLayer: some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
    }
}
