//
//  SearchResultItem.swift
//  WikiSearch
//
//  Created by Teaualune Tseng on 2019/11/4.
//  Copyright © 2019 Zencher Co., Ltd. All rights reserved.
//

import Foundation

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

