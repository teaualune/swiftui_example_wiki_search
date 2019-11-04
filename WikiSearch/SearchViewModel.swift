//
//  SearchViewModel.swift
//  WikiSearch
//
//  Created by Teaualune Tseng on 2019/10/15.
//  Copyright © 2019 Zencher Co., Ltd. All rights reserved.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {

    private let searchRepository: SearchRepository

    var limit = 10

    @Published var searchResult: [SearchResultItem] = []

    @Published var searchText: String = ""

    private var cancellable = Set<AnyCancellable>()

    init(searchRepository: SearchRepository) {

        self.searchRepository = searchRepository

        let searchTextStream = $searchText
            .dropFirst(1)
            .debounce(for: 1, scheduler: RunLoop.main)
            .removeDuplicates()

        searchTextStream
            .sink { text in
                if text.count == 0 {
                    self.searchResult = []
                }
            }
            .store(in: &cancellable)

        searchTextStream
            .filter { $0.count > 0 }
            .flatMap { searchText in
                self.searchRepository.search(by: searchText, limit: self.limit)
            }
            .breakpoint(receiveOutput: { data in
                print(data)
                return false
            })
            .receive(on: RunLoop.main)
            .sink { result in
                self.searchResult = result
            }
            .store(in: &cancellable)
    }
}
