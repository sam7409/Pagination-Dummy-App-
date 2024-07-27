//
//  ViewModel.swift
//  PaginationDummy
//
//  Created by Neeshu Kumar on 26/07/24.
//

import Combine
import SwiftUI

class PaginationViewModel: ObservableObject {
    @Published var images: [Hit] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let networkService: NetworkServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private var currentPage = 1
    private var totalHits = 0

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
        fetchHits()
    }

    func fetchHits() {
        guard !isLoading else { return }

        isLoading = true
        networkService.fetchImages(page: currentPage) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    self?.images.append(contentsOf: response.hits)
                    self?.totalHits = response.totalHits
                    self?.currentPage += 1
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
