//
//  NetworkService.swift
//  TheCatApi
//
//  Created by Dmitry Khalitov on 3/30/25.
//

import Cocoa


enum APIConfig {
    static let apiKey = "live_JRChKMsNr44xmkVP9oP05ZoPai9r0Gsu4o5RZMTolUctftA6lZ6TPc3a2Yu3uSH0"
}

protocol NetworkService {
    func fetchBreeds(completion: @escaping (Result<[CatBreed], Error>) -> Void)
    func fetchBreedImage(forBreedId breedId: String, completion: @escaping (Result<Data, Error>) -> Void)
}

final class NetworkServiceImpl {
    private let decoder: JSONDecoder
    private let imageCache: NSCache<NSString, NSData>
    
    init() {
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.imageCache = NSCache<NSString, NSData>()
    }
    
    func makeRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue(APIConfig.apiKey, forHTTPHeaderField: "x-api-key")
        return request
    }
    
    private func fetchBreedImageUrl(forId breedId: String, limit: Int = 1, completion: @escaping (Result<String,  Error>) -> Void) {
        guard let url = URL(string: "https://api.thecatapi.com/v1/images/search?order=ASC&limit=\(limit)&breed_ids=\(breedId)") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: self.makeRequest(url: url)) { data, response, error in
            if let error {
                completion(.failure(error))
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "fetchBreedImageUrl - data: DataNil", code: 0)))
                return
            }
            
            do {
                let result = try self.decoder.decode([CatImage].self, from: data)
//                print("@@@ fetchBreedImageUrl RESULT: \(result)")
                guard let imageUrl = result.first?.url else {
                    completion(.failure(NSError(domain: "fetchBreedImageUrl - imageUrl: DataNil for \(breedId)", code: 0)))
                    return
                }
                completion(.success(imageUrl))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private func fetchBreedImageUrls(forId breedId: String, limit: Int = 1, completion: @escaping (Result<[String],  Error>) -> Void) {
        guard let url = URL(string: "https://api.thecatapi.com/v1/images/search?order=ASC&limit=\(limit)&breed_ids=\(breedId)") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: self.makeRequest(url: url)) { data, response, error in
            if let error {
                completion(.failure(error))
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "fetchBreedImageUrl - data: DataNil", code: 0)))
                return
            }
            
            do {
                let result = try self.decoder.decode([CatImage].self, from: data)
                var arrayWithUrls: [String] = []
                for catImage in result {
                    arrayWithUrls.append(catImage.url)
                }
                completion(.success(arrayWithUrls))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private func fetchImage(fromUrl url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
//        print("1 - START get image for url: \(url)")
        
        if let cachedImage = imageCache.object(forKey: NSString(string: url)) {
            completion(.success(cachedImage as Data))
//            print("2 - get from cash for url: \(url)")
        }
        else {
            guard let url = URL(string: url) else {
                completion(.failure(URLError(.badURL)))
                print("3 - bad url: \(url)")
                return
            }
            let task = URLSession.shared.dataTask(with: self.makeRequest(url: url)) { data, response, error in
                if let error {
                    completion(.failure(error))
                    print("4 - failure for url: \(url), error: \(error)")
                }
                guard let data = data else {
                    completion(.failure(NSError(domain: "fetchImage - data: DataNil", code: 0)))
                    print("5 - failure get data for url: \(url)")
                    return
                }
//                print("6 - finish for url: \(url)")
                self.imageCache.setObject(data as NSData, forKey: NSString(string: url.absoluteString))
//                print("7 - finish for url: \(url)")
                completion(.success(data))
//                print("8 - finish for url: \(url)")
            }
            task.resume()
        }
    }
}

extension NetworkServiceImpl: NetworkService {
    
    func fetchBreeds(completion: @escaping (Result<[CatBreed], Error>) -> Void) {
        guard let url = URL(string: "https://api.thecatapi.com/v1/breeds") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: self.makeRequest(url: url)) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "DataNil", code: 0)))
                return
            }
            
            do {
                let breeds = try self.decoder.decode([CatBreed].self, from: data)
                completion(.success(breeds))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchBreedImage(forBreedId breedId: String, completion: @escaping (Result<Data, Error>) -> Void) {
        self.fetchBreedImageUrl(forId: breedId) { [weak self] result in
            switch result {
            case .success(let url):
                guard let self = self else { return }
                self.fetchImage(fromUrl: url) { result in
                    switch result {
                    case .success(let data):
                        completion(.success(data))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
