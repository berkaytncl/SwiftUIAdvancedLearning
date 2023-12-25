//
//  DependencyInjectionBootcamp.swift
//  SwiftUIAdvancedLearning
//
//  Created by Berkay Tuncel on 25.12.2023.
//

import SwiftUI
import Combine

// PROBLEMS WITH SINGLETONS
// 1. Singleton's are GLOBAL
// 2. Can't customize the init!
// 3. Can't swap out dependencies

struct PostsModel: Identifiable, Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

protocol DataServiceProtocol {
    func getData() -> AnyPublisher<[PostsModel], Error>
}

class ProductionDataService: DataServiceProtocol {
    
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func getData() -> AnyPublisher<[PostsModel], Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map({ $0.data })
            .decode(type: [PostsModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

class MockDataService: DataServiceProtocol {
    
    let testData: [PostsModel]
    
    init(data: [PostsModel]? = nil) {
        self.testData = data ?? [
            PostsModel(userId: 1, id: 1, title: "title1", body: "body1"),
            PostsModel(userId: 2, id: 2, title: "title2", body: "body2")
        ]
    }
    
    func getData() -> AnyPublisher<[PostsModel], Error> {
        Just(testData)
            .tryMap({ $0 })
            .eraseToAnyPublisher()
    }
}

//class Dependencies {
//    
//    let dataService: DataServiceProtocol
//    
//    init(dataService: DataServiceProtocol) {
//        self.dataService = dataService
//    }
//}

class DependencyInjectionViewModel: ObservableObject {
    
    @Published var dataArray: [PostsModel] = []
    var cancellables = Set<AnyCancellable>()
    let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
        loadPosts()
    }
    
    private func loadPosts() {
        dataService.getData()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error): print("Error: \(error)")
                case .finished: print("finished successfully")
                }
            }, receiveValue: { [weak self] returnedPosts in
                self?.dataArray = returnedPosts
            })
            .store(in: &cancellables)
    }
}

struct DependencyInjectionBootcamp: View {
    
    @StateObject private var viewModel: DependencyInjectionViewModel
    
    init(dataService: DataServiceProtocol) {
        _viewModel = StateObject(wrappedValue: DependencyInjectionViewModel(dataService: dataService))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.dataArray) { post in
                    Text(post.title)
                }
            }
        }
    }
}

#Preview {
    
//    let dataService = ProductionDataService(url: URL(string: "https://jsonplaceholder.typicode.com/posts")!)
    let dataService = MockDataService(data: [
        PostsModel(userId: 1234, id: 1234, title: "test", body: "test")
    ])
    
    return DependencyInjectionBootcamp(dataService: dataService)
}
