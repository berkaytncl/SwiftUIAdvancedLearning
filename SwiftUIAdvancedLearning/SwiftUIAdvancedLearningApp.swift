//
//  SwiftUIAdvancedLearningApp.swift
//  SwiftUIAdvancedLearning
//
//  Created by Berkay Tuncel on 17.12.2023.
//

import SwiftUI

@main
struct SwiftUIAdvancedLearningApp: App {
    
    let currentUserIsSignedIn: Bool
    
    init() {
//        let userIsSignedIn: Bool = CommandLine.arguments.contains("-UITest_startSignedIn") ? true : false
        let userIsSignedIn: Bool = ProcessInfo.processInfo.arguments.contains("-UITest_startSignedIn") ? true : false
//        let value = ProcessInfo.processInfo.environment["-UITest_startSignedIn2"]
//        let userIsSignedIn: Bool = value == "true" ? true : false
        currentUserIsSignedIn = userIsSignedIn
    }
    
    var body: some Scene {
        WindowGroup {
//            UITestingBootcampView(currentUserIsSignedIn: currentUserIsSignedIn)
            ErrorAlertBootcamp()
        }
    }
}
