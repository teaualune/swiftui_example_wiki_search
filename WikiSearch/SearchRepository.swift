//
//  SearchRepository.swift
//  WikiSearch
//
//  Created by Teaualune Tseng on 2019/11/4.
//  Copyright © 2019 Zencher Co., Ltd. All rights reserved.
//

import Foundation
import Combine

class SearchRepository {

    func search(by keyword: String, limit: Int) -> AnyPublisher<[SearchResultItem], Never> {
        guard let keyword = keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return Just([]).eraseToAnyPublisher()
        }
        return URLSession.DataTaskPublisher(request: URLRequest(url: URL(string: "https://en.wikipedia.org/w/api.php?action=opensearch&search=\(keyword)&limit=\(limit)&namespace=0&format=json")!), session: .shared)
        .map { $0.data }
        .catch { err -> Just<Data?> in
            print(err)
            return Just(nil)
        }
        .compactMap { data -> [SearchResultItem]? in
            if let data = data {
                return self.parseSearchResult(data: data)
            }
            return nil
        }
        .eraseToAnyPublisher()
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
