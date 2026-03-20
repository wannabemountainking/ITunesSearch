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
    @State private var isProgressing: Bool = false
    @State private var errorMessage: String? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
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
                        self.isProgressing = true
                        Task {
                            do {
                                try await vm.getMusicInfo()
                                self.errorMessage = nil
                                self.isProgressing = false
                            } catch {
                                self.errorMessage = "검색 결과가 없습니다"
                                self.isProgressing = false
                            }
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
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
                if let error = self.errorMessage {
                    Text(error)
                    Spacer()
                } else if self.isProgressing {
                    ProgressView {
                        Text("searching...")
                    }
                    Spacer()
                } else {
                    Text("총 결과: \(String(vm.numberOfResults)) 개")
                    List {
                        ForEach(vm.trackResults) { track in
                            Section {
                                ForEach(track.trackInfo,
                                    id: \.label
                                )
                                { (label, info) in
                                    if let info {
                                        Text(info)
                                    }
                                } //:LOOP
                            } header: {
                                if let trackTitle = track.trackName {
                                    Text("🎶 \(trackTitle)")
                                }
                            }//:SECTION
                        } //:LOOP
                    } //:LIST
                    Spacer()
                }//:CONDITIONAL
            } //:VSTACK
            .navigationTitle("🎵 iTunes Search")
            .navigationBarTitleDisplayMode(.inline)
        } //:NAVIGATION
    }//:body
}

#Preview {
    MainView()
}
