//
//  UITestingBootcampView_UITests.swift
//  SwiftUIAdvancedLearning_UITests
//
//  Created by Berkay Tuncel on 27.12.2023.
//

import XCTest

// Naming Structure: test_UnitOfWork_StateUnderTest_ExpectedBehavior
// Naming Structure: test_[struct]_[ui component]_[expected result]

// Testing Structure: Given, When, Then

final class UITestingBootcampView_UITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
//        app.launchArguments = ["-UITest_startSignedIn"]
//        app.launchEnvironment = ["-UITest_startSignedIn2" : "true"]
        app.launch()
    }

    override func tearDownWithError() throws {
    }
    
    func test_UITestingBootcampView_signUpButton_shouldNotSignIn() {
        // Given
        signUpAndSignIn(shouldTypeOnKeyboard: false)
        
        // When
        let navBar = app.navigationBars["Welcome"]
        
        // Then
        XCTAssertFalse(navBar.exists)
    }
    
    func test_UITestingBootcampView_signUpButton_shouldSignIn() {
        // Given
        signUpAndSignIn()
        
        // When
        let navBar = app.navigationBars["Welcome"]
        
        // Then
        XCTAssertTrue(navBar.exists)
    }
    
    func test_SignedInHomeView_showAlertButton_shouldDisplayAlert() {
        // Given
        signUpAndSignIn()
        
        // When
        tapAlertButton()
                
        // Then
        let alert = app.alerts.firstMatch
        XCTAssertTrue(alert.exists)
    }
    
    func test_SignedInHomeView_showAlertButton_shouldDisplayAndDismissAlert() {
        // Given
        signUpAndSignIn()
        
        // When
        tapAlertButton(shouldDismissAlert: true)
        
        // Then
        let alertExists = app.alerts.firstMatch.waitForExistence(timeout: 5)
        XCTAssertFalse(alertExists)
    }
    
    func test_SignedInHomeView_NavigationLinkToDestination_shouldNavigateToDestination() {
        // Given
        signUpAndSignIn()
        
        // When
        tapNavigationLink()
        
        // Then
        let destinationText = app.staticTexts["Destination"]
        XCTAssertTrue(destinationText.exists)
    }
    
    func test_SignedInHomeView_NavigationLinkToDestination_shouldNavigateToDestinationAndGoBack() {
        // Given
        signUpAndSignIn()
        
        // When
        tapNavigationLink(shouldDismissDestination: true)
        
        // Then
        let navBar = app.navigationBars["Welcome"]
        XCTAssertTrue(navBar.exists)
    }
    
//    func test_SignedInHomeView_NavigationLinkToDestination_shouldNavigateToDestinationAndGoBack2() {
//        // Given
//        
//        // When
//        tapNavigationLink(shouldDismissDestination: true)
//        
//        // Then
//        let navBar = app.navigationBars["Welcome"]
//        XCTAssertTrue(navBar.exists)
//    }
}

// MARK: FUNCTIONS

extension UITestingBootcampView_UITests {
    
    func signUpAndSignIn(shouldTypeOnKeyboard: Bool = true) {
        let textfield = app.textFields["SignUpTextField"]
        textfield.tap()
        
        if shouldTypeOnKeyboard {
            let keyA = app.keys["A"]
            keyA.tap()
            
            let akey = app.keys["a"]
            akey.tap()
            akey.tap()
        }
        
        let returnButton = app.buttons["Return"]
        returnButton.tap()
        
        let signUpButton = app.buttons["SignUpButton"]
        signUpButton.tap()
    }
    
    func tapAlertButton(shouldDismissAlert: Bool = false) {
        let showAlertButton = app.buttons["ShowAlertButton"]
        showAlertButton.tap()
        
        if shouldDismissAlert {
            let alert = app.alerts.firstMatch

            let alertOKButton = alert.buttons["OK"]
            let alertOKButtonExists = alertOKButton.waitForExistence(timeout: 5)
            XCTAssertTrue(alertOKButtonExists)
            
            alertOKButton.tap()
        }
    }

    func tapNavigationLink(shouldDismissDestination: Bool = false) {
        let navLinkButton = app.buttons["NavigationLinkToDestination"]
        navLinkButton.tap()
        
        if shouldDismissDestination {
            let backButton = app.navigationBars.buttons["Welcome"]
            backButton.tap()
        }
    }
    
}
