//
//  NetworkServices.swift
//  PaginationDummy
//
//  Created by Neeshu Kumar on 26/07/24.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchImages(page: Int, completion: @escaping (Result<PixabayResponse, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    private let baseURL = "https://pixabay.com/api/"
    private let apiKey = "45128730-126229a07d03d7d0bc97dccd1"
    private let category = "Nature"

    func fetchImages(page: Int, completion: @escaping (Result<PixabayResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)?key=\(apiKey)&page=\(page)&category=\(category)") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else { return }

            do {
                let response = try JSONDecoder().decode(PixabayResponse.self, from: data)
                completion(.success(response))
            } catch let decodeError {
                completion(.failure(decodeError))
            }
        }.resume()
    }
}
