//
//  SearchViewModel.swift
//  WikiSearch
//
//  Created by Teaualune Tseng on 2019/10/15.
//  Copyright © 2019 Zencher Co., Ltd. All rights reserved.
//

import Foundation
import Combine

enum SearchResultEnum: Codable {
    case searchText(String)
    case resultArray([String])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let text = try? container.decode(String.self) {
            self = .searchText(text)
        } else if let array = try? container.decode([String].self) {
            self = .resultArray(array)
        } else {
            throw DecodingError.typeMismatch(SearchResultEnum.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Neither string nor array of strings were found"))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .searchText(let text):
            try container.encode(text)
        case .resultArray(let array):
            try container.encode(array)
        }
    }

    static func retrieveArray(resultEnum: SearchResultEnum) -> [String]? {
        switch resultEnum {
        case .resultArray(let array):
            return array
        default:
            return nil
        }
    }
}

struct SearchResultItem: Identifiable {
    var name: String
    var description: String
    var url: String

    var id: String {
        return name
    }
}

class SearchViewModel: ObservableObject {

    var limit = 10

    @Published var searchResult: [SearchResultItem] = []

    @Published var searchText: String = ""

    private var cancellable = Set<AnyCancellable>()

    init() {
        $searchText
            .dropFirst(1)
            .debounce(for: 1, scheduler: RunLoop.main)
            .removeDuplicates()
            .filter { $0.count > 0 }
            .compactMap { $0.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) }
//            .filter { $0 != nil }
//            .map { $0! }
            .setFailureType(to: URLError.self)
            .flatMap { searchText -> URLSession.DataTaskPublisher in
                return URLSession.DataTaskPublisher(request: URLRequest(url: URL(string: "https://en.wikipedia.org/w/api.php?action=opensearch&search=\(searchText)&limit=\(self.limit)&namespace=0&format=json")!), session: .shared)
            }
            .compactMap { self.parseSearchResult(data: $0.data) }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                print(completion)
            }) { result in
                self.searchResult = result
            }
//            }) { (data: Data, response: URLResponse) in
//                if let result = self.parseSearchResult(data: data) {
//                    self.searchResult = result
//                }
//            }
            .store(in: &cancellable)
    }

    private func parseSearchResult(data: Data) -> [SearchResultItem]? {
        let decoder = JSONDecoder()
        if
            let decodeResult = try? decoder.decode(Array<SearchResultEnum>.self, from: data),
            decodeResult.count == 4,
            let names = SearchResultEnum.retrieveArray(resultEnum: decodeResult[1]),
            let descriptions = SearchResultEnum.retrieveArray(resultEnum: decodeResult[2]),
            let urls = SearchResultEnum.retrieveArray(resultEnum: decodeResult[3]),
            names.count == descriptions.count && descriptions.count == urls.count
        {
            return names.enumerated().map { (index, name) -> SearchResultItem in
                return SearchResultItem(name: name, description: descriptions[index], url: urls[index])
            }
        }
        return nil
    }
}
