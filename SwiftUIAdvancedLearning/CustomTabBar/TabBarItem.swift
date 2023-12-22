//
//  TabBarItem.swift
//  SwiftUIAdvancedLearning
//
//  Created by Berkay Tuncel on 21.12.2023.
//

import SwiftUI

enum TabBarItem: Hashable {
    case home, favorites, profile, messages
    
    var iconName: String {
        switch self {
        case .home: "house"
        case .favorites: "heart"
        case .profile: "person"
        case .messages: "message"
        }
    }
    
    var title: String {
        switch self {
        case .home: "Home"
        case .favorites: "Favorites"
        case .profile: "Profile"
        case .messages: "Messages"
        }
    }
    
    var color: Color {
        switch self {
        case .home: .red
        case .favorites: .orange
        case .profile: .green
        case .messages: .blue
        }
    }
}
