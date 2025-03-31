//
//  NetworkService.swift
//  TheCatApi
//
//  Created by Dmitry Khalitov on 3/30/25.
//

import Foundation


enum APIConfig {
    static let apiKey = "live_JRChKMsNr44xmkVP9oP05ZoPai9r0Gsu4o5RZMTolUctftA6lZ6TPc3a2Yu3uSH0"
}

final class NetworkService {
    
    func makeRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue(APIConfig.apiKey, forHTTPHeaderField: "x-api-key")
        return request
    }
    
    func fetchBreeds(completion: @escaping (Result<[CatBreed], Error>) -> Void) {
        let url = URL(string: "https://api.thecatapi.com/v1/breeds")!
                
        let task = URLSession.shared.dataTask(with: self.makeRequest(url: url)) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "DataNil", code: 0)))
                return
            }
            
            do {
                let breeds = try JSONDecoder().decode([CatBreed].self, from: data)
                completion(.success(breeds))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    
}
