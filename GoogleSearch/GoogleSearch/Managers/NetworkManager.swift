//
//  NetworkManager.swift
//  GoogleSearch
//
//  Created by Egor Mikhalevich on 19.12.21.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()

    private var task: URLSessionDataTask?
    private let session = URLSession(configuration: .default)
    private let urlSession = URLSession.shared

    func fetchSearchData(
        with request: String?,
        completion: @escaping (Result<ResponseResult, NetworkError>) -> Void,
        progress: @escaping (Progress) -> Void
    ) {
        if !InternetConnectionObserver.isInternetAvailable() {
            completion(.failure(.noConnection))
            return
        }

        guard let request = request else {
            return
        }
        guard let url = URL(string: APIEndpoints.mainUrl) else {
            completion(.failure(.apiError))
            return
        }
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        let queryItems = [
            URLQueryItem(name: APIQueryItems.key, value: APIEndpoints.apiKey),
            URLQueryItem(name: APIQueryItems.cx, value: APIEndpoints.cx),
            URLQueryItem(name: APIQueryItems.q, value: request),
        ]
        urlComponents.queryItems = queryItems
        guard let finalURL = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }

        self.task = session.dataTask(with: finalURL) { data, response, error in
            DispatchQueue.main.async {
                if error != nil {
                    completion(.failure(.apiError))
                }
                guard let data = data, let response = response as? HTTPURLResponse, 200 ..< 300 ~= response.statusCode else {
                    completion(.failure(.invalidDataOrResponse))
                    return
                }
                do {
                    let decodeResponse = try JSONDecoder().decode(ResponseResult.self, from: data)
                    completion(.success(decodeResponse))
                } catch {
                    completion(.failure(.serializationError))
                }
            }
        }
        guard let task = task else {
            completion(.failure(.serializationError))
            return
        }
        progress(task.progress)
        task.resume()
    }

    func cancelTask() {
        guard let task = task else { return }
        task.cancel()
    }
}
