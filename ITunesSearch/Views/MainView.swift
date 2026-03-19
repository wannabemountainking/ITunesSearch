//
//  MainView.swift
//  ITunesSearch
//
//  Created by YoonieMac on 3/19/26.
//

import SwiftUI

struct MainView: View {
    
    @State private var vm: NetworkViewModel = .init()
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section("검색") {
                    LabeledContent {
                        // content View
                        TextField("아티스트 입력", text: $searchText)
                            .font(.title2)
                            .fontWeight(.ultraLight)
                            .frame(height: 35)
                            .textFieldStyle(.roundedBorder)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                    } label: {
                        Text("검색창: ")
                            .font(.title3.bold())
                    }
                    
                    Button("Search") {
                        vm.modifiedText = searchText.replacingOccurrences(of: " ", with: "+")
                        do {
                            try vm.getTracksInfo()
                        } catch {
                            print(error)
                        }
                    }
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(height: 35)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                Section("총 결과: \(String(vm.numberOfResults)) 개") {
                    ForEach(vm.trackResults) { track in
                        Section {
                            if let trackTitle = track.trackName {
                                Text("🎶 \(trackTitle)")
                            }
                            if let artist = track.artistName {
                                Text(artist)
                            }
                            if let collectionTitle = track.collectionName {
                                Text(collectionTitle)
                            }
                            if let genre = track.primaryGenreName {
                                Text(genre)
                            }
                        }
                    }
                }
            }
            .navigationTitle("🎵 iTunes Search")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    MainView()
}
