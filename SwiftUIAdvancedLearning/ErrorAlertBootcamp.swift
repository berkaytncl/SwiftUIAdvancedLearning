//
//  ErrorAlertBootcamp.swift
//  SwiftUIAdvancedLearning
//
//  Created by Berkay Tuncel on 31.12.2023.
//

import SwiftUI

// Error
// Alert

protocol AppAlert {
    var title: String { get }
    var subtitle: String? { get }
    var buttons: AnyView { get }
}

extension View {
    func showCustomAlert<T: AppAlert>(alert: Binding<T?>) -> some View {
        self
            .alert(alert.wrappedValue?.title ?? "Error", isPresented: Binding(value: alert), actions: {
                alert.wrappedValue?.buttons
            }, message: {
                if let subtitle = alert.wrappedValue?.subtitle {
                    Text(subtitle)
                }
            })
    }
}

struct ErrorAlertBootcamp: View {
    
    @State private var alert: MyCustomAlert? = nil
    
    var body: some View {
        Button("Click me") {
            saveData()
        }
        .showCustomAlert(alert: $alert)
//        .alert(alert?.title ?? "Error", isPresented: Binding(value: $alert)) {
//            alert?.getButtonsForAlert
//        } message: {
//            if let subtitle = alert?.subtitle {
//                Text(subtitle)
//            }
//        }
    }
    
//    enum MyCustomError: Error, LocalizedError {
//        case noInternetConnection
//        case dataNotFound
//        case urlError(error: Error)
//        
//        var errorDescription: String? {
//            switch self {
//            case .noInternetConnection:
//                "Please check your internet connection and try again."
//            case .dataNotFound:
//                "There was an error loading data. Please try again!"
//            case .urlError(error: let error):
//                "Error: \(error.localizedDescription)"
//            }
//        }
//    }
    
    enum MyCustomAlert: Error, LocalizedError, AppAlert {
        case noInternetConnection(onOkPressed: () -> (), onRetryPressed: () -> ())
        case dataNotFound
        case urlError(error: Error)
        
        var errorDescription: String? {
            switch self {
            case .noInternetConnection:
                "Please check your internet connection and try again."
            case .dataNotFound:
                "There was an error loading data. Please try again!"
            case .urlError(error: let error):
                "Error: \(error.localizedDescription)"
            }
        }
        
        var title: String {
            switch self {
            case .noInternetConnection:
                "No Internet Connection"
            case .dataNotFound:
                "No Data"
            case .urlError:
                "Error"
            }
        }
        
        var subtitle: String? {
            switch self {
            case .noInternetConnection:
                "Please check your internet connection and try again."
            case .dataNotFound:
                nil
            case .urlError(error: let error):
                "Error: \(error.localizedDescription)"
            }
        }
        
        var buttons: AnyView {
            AnyView(getButtonsForAlert)
        }
        
        @ViewBuilder private var getButtonsForAlert: some View {
            switch self {
            case .noInternetConnection(onOkPressed: let onOkPressed, onRetryPressed: let onRetryPressed):
                Button("OK") {
                    onOkPressed()
                }
                Button("RETRY") {
                    onRetryPressed()
                }
            case .dataNotFound:
                Button("RETRY") {
                    
                }
            default:
                Button("DELETE", role: .destructive) {
                    
                }
            }
        }
    }
    
    private func saveData() {
        let isSuccessful: Bool = false
        
        if isSuccessful {
            // do something
        } else {
            alert = .noInternetConnection(onOkPressed: {
                
            }, onRetryPressed: {
                
            })
        }
    }
}

#Preview {
    ErrorAlertBootcamp()
}
