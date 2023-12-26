//
//  UnitTestingBootcampView.swift
//  SwiftUIAdvancedLearning
//
//  Created by Berkay Tuncel on 25.12.2023.
//

/*
 1. Unit Tests
 - test the business logic in your app
 
 2. UI Tests
 - tests the UI of your app
 */

import SwiftUI

struct UnitTestingBootcampView: View {
    
    @StateObject private var viewModel: UnitTestingBootcampViewModel
    
    init(isPremium: Bool, dataService: NewDataServiceProtocol) {
        _viewModel = StateObject(wrappedValue: UnitTestingBootcampViewModel(isPremium: isPremium, dataService: dataService))
    }
    
    var body: some View {
        Text(viewModel.isPremium.description)
    }
}

#Preview {
    let dataService: NewDataServiceProtocol = NewMockDataService(items: nil)
    
    return UnitTestingBootcampView(isPremium: true, dataService: dataService)
}
