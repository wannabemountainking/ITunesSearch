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

@MainActor
@Observable
final class NetworkViewModel {
    
    typealias NetworkDataCompletion = (_ data: Data?) -> ()
    
    var modifiedText: String = ""
    var numberOfResults: Int = 0
    var trackResults: [Track] = []
    
    func getMusicInfo() async throws {
        let endpoint = "https://itunes.apple.com/search?term=\(modifiedText)&limit=20"
        guard let url = URL(string: endpoint) else {
            throw NetworkError.invalidURL
        }
        
        let tracks = try await downloadData(url)
        self.numberOfResults = tracks.resultCount
        self.trackResults = tracks.results
    }
    
    func downloadData(_ url: URL) async throws -> Tracks {
        
        let (data, response) = try await URLSession.shared.data(from: url)
        try await Task.sleep(for: .seconds(5))
        guard let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkError.invalidResponse
        }
        let tracks = try JSONDecoder().decode(Tracks.self, from: data)
        return tracks
    }
    
}



//@Observable
//final class NetworkViewModel {
//    
//    typealias NetworkDataCompletion = (_ data: Data?) -> ()
//    
//    var modifiedText: String = ""
//    var numberOfResults: Int = 0
//    var trackResults: [Track] = []
//    var isProgressing: Bool = false
//    var errorMessage: String? = nil
//    
//    func getTracksInfo() throws {
//        print(#function)
//        let endpoint: String = "https://itunes.apple.com/search?term=\(modifiedText)&limit=20"
//        guard let url = URL(string: endpoint) else {
//            self.errorMessage = "검색 결과가 없습니다"
//            self.isProgressing = false
//            throw NetworkError.invalidURL
//        }
//        
//        downloadData(url) { downloadedData in
//            guard let data = downloadedData else {
//                DispatchQueue.main.async { [weak self] in
//                    guard let self else {return}
//                    self.errorMessage = "검색 결과가 없습니다"
//                    self.isProgressing = false
//                }
//                return
//            }
//            guard let decodedData = try? JSONDecoder().decode(Tracks.self, from: data) else {
//                DispatchQueue.main.async { [weak self] in
//                    guard let self else {return}
//                    self.errorMessage = "검색 결과가 없습니다"
//                    self.isProgressing = false
//                }
//                return
//            }
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
//                guard let self else {return}
//                self.numberOfResults = decodedData.resultCount
//                self.trackResults = decodedData.results
//                self.errorMessage = nil
////                if self.trackResults.isEmpty {
////                    self.errorMessage = "검색 결과가 없습니다"
////                } else {
////                    self.errorMessage = nil
////                }
//                isProgressing = false
//            }
//        }
//    }
//    
//    func downloadData(_ url: URL, completionHandler: @escaping NetworkDataCompletion) {
//        print(#function)
//        let task = URLSession.shared.dataTask(with: url) { data, res, err in
//            guard err == nil else {
//                DispatchQueue.main.async {
//                    self.errorMessage = "검색 결과가 없습니다"
//                    self.isProgressing = false
//                }
//                completionHandler(nil)
//                return
//            }
//            guard let res = res as? HTTPURLResponse,
//                  res.statusCode >= 200 && res.statusCode < 300 else {
//                DispatchQueue.main.async {
//                    self.errorMessage = "검색 결과가 없습니다"
//                    self.isProgressing = false
//                }
//                completionHandler(nil)
//                return
//            }
//            guard let safeData = data else {
//                DispatchQueue.main.async {
//                    self.errorMessage = "검색 결과가 없습니다"
//                    self.isProgressing = false
//                }
//                completionHandler(nil)
//                return
//            }
//            
//            DispatchQueue.main.async {
//                self.errorMessage = nil
//            }
//            
//            completionHandler(safeData)
//        }
//        task.resume()
//    }
//    
//}
