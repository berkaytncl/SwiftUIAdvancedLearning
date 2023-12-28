//
//  UITestingBootcampView.swift
//  SwiftUIAdvancedLearning
//
//  Created by Berkay Tuncel on 27.12.2023.
//

import SwiftUI

class UITestingBootcampViewModel: ObservableObject {
    
    let placeholderText: String = "Add your name..."
    @Published var textFieldText: String = ""
    @Published var currentUserIsSignedIn: Bool
    
    init(currentUserIsSignedIn: Bool) {
        self.currentUserIsSignedIn = currentUserIsSignedIn
    }
    
    func signUpButtonPressed() {
        guard !textFieldText.isEmpty else { return }
        currentUserIsSignedIn = true
    }
}

struct UITestingBootcampView: View {
    
    @StateObject private var viewModel: UITestingBootcampViewModel
    
    init(currentUserIsSignedIn: Bool) {
        _viewModel = StateObject(wrappedValue: UITestingBootcampViewModel(currentUserIsSignedIn: currentUserIsSignedIn))
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.black]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            ZStack {
                if viewModel.currentUserIsSignedIn {
                    SignedInHomeView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .transition(.move(edge: .trailing))
                } else {
                    signUpLayer
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .transition(.move(edge: .leading))
                }
            }
        }
    }
}

#Preview {
    UITestingBootcampView(currentUserIsSignedIn: false)
}

extension UITestingBootcampView {
    private var signUpLayer: some View {
        VStack {
            TextField(viewModel.placeholderText, text: $viewModel.textFieldText)
                .font(.headline)
                .padding()
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .accessibilityIdentifier("SignUpTextField")
            
            Button(action: {
                withAnimation(.spring) {
                    viewModel.signUpButtonPressed()
                }
            }, label: {
                Text("Sign Up")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .accessibilityIdentifier("SignUpButton")
            })
        }
        .padding()
    }
}

struct SignedInHomeView: View {
    
    @State private var showAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                Button(action: {
                    showAlert.toggle()
                }, label: {
                    Text("Show welcome alert!")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .background(.red)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                })
                .accessibilityIdentifier("ShowAlertButton")
                .alert("Welcome to the app!", isPresented: $showAlert, actions: {})
                
                NavigationLink {
                    Text("Destination")
                } label: {
                    Text("Navigate")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .accessibilityIdentifier("NavigationLinkToDestination")
            }
            .padding()
            .navigationTitle("Welcome")
        }
    }
}
