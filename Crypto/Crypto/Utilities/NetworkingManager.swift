//
//  NetworkingManager.swift
//  Crypto
//
//  Created by Pratyush  on 6/14/21.
//

import Foundation
import Combine

class NetworkingManager {
    
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(let url): return "[🔥] Bad response from \(url.absoluteString)"
            case .unknown: return "[⚠️] unknown error return"
            }
        }
    }
    
    private init() { }
    
    class func downloadData(url: URL) -> AnyPublisher<Data, Error> {
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({try handleURLResponse(output: $0, url: url)})
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    class func handleCompletion(completion: Subscribers.Completion<Never>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error)
        }
    }
    
    private class func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws  -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300  else {
            throw NetworkingError.badURLResponse(url: url)
        }
        return output.data
    }
}
