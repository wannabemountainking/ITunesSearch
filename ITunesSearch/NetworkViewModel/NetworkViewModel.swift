//
//  NetworkViewModel.swift
//  ITunesSearch
//
//  Created by YoonieMac on 3/19/26.
//

import Foundation
import Observation


enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case idontknowError
}

@Observable
final class NetworkViewModel {
    
    typealias NetworkDataCompletion = (_ data: Data?) -> ()
    
    var modifiedText: String = ""
    var numberOfResults: Int = 0
    var trackResults: [Track] = []
    
    func getTracksInfo() throws {
        print(#function)
        let endpoint: String = "https://itunes.apple.com/search?term=\(modifiedText)&limit=20"
        guard let url = URL(string: endpoint) else {
            throw NetworkError.invalidURL
        }
        
        downloadData(url) { downloadedData in
            guard let data = downloadedData else {return}
            guard let decodedData = try? JSONDecoder().decode(Tracks.self, from: data) else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self else {return}
                self.numberOfResults = decodedData.resultCount
                self.trackResults = decodedData.results
                print(self.trackResults)
            }
        }
    }
    
    func downloadData(_ url: URL, completionHandler: @escaping NetworkDataCompletion) {
        print(#function)
        let task = URLSession.shared.dataTask(with: url) { data, res, err in
            guard err == nil else {
                completionHandler(nil)
                return
            }
            guard let res = res as? HTTPURLResponse,
                  res.statusCode >= 200 && res.statusCode < 300 else {
                completionHandler(nil)
                return
            }
            guard let safeData = data else {
                completionHandler(nil)
                return
            }
            completionHandler(safeData)
        }
        task.resume()
    }
    
}
