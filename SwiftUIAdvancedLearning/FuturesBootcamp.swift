//
//  FuturesBootcamp.swift
//  SwiftUIAdvancedLearning
//
//  Created by Berkay Tuncel on 29.12.2023.
//

import SwiftUI
import Combine

// download with Combine
// download with @escaping closure
// convert @escaping closure to Combine


class FuturesBootcampViewModel: ObservableObject {
    
    @Published var title: String = "Starting title"
    @Published var title2: String = "Starting title"
    let url = URL(string: "https://www.google.com")!
    var cancellables = Set<AnyCancellable>()
    
    init() {
        download()
    }
    
    func download() {
//        getCombinePublisher()
        getFuturePublisher()
            .sink { _ in
                
            } receiveValue: { [weak self] value in
                self?.title = value
            }
            .store(in: &cancellables)
        
//        getEscapingClosure { [weak self] value, error in
//            self?.title = value
//        }
        
        doSomethingInTheFuture()
            .sink { [weak self] value in
                self?.title2 = value
            }
            .store(in: &cancellables)
    }
    
    func getCombinePublisher() -> AnyPublisher<String, URLError> {
        URLSession.shared.dataTaskPublisher(for: url)
            .timeout(1, scheduler: DispatchQueue.main)
            .map({ _ in
                return "New value"
            })
            .eraseToAnyPublisher()
    }
    
    func getEscapingClosure(completionHandler: @escaping (_ value: String, _ error: Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completionHandler("New value 2", nil)
        }
        .resume()
    }
    
    func getFuturePublisher() -> Future<String, Error> {
        return Future { [weak self] promise in
            self?.getEscapingClosure { value, error in
                if let error {
                    promise(.failure(error))
                } else {
                    promise(.success(value))
                }
            }
        }
    }
    
    func doSomething(completion: @escaping (_ value: String) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            completion("New String")
        }
    }
    
    func doSomethingInTheFuture() -> Future<String, Never> {
        return Future { [weak self] promise in
            self?.doSomething { value in
                promise(.success(value))
            }
        }
    }
}

struct FuturesBootcamp: View {
    
    @StateObject private var viewModel = FuturesBootcampViewModel()
    
    var body: some View {
        Text(viewModel.title)
        Text(viewModel.title2)
    }
}

#Preview {
    FuturesBootcamp()
}
