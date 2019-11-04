//
//  SearchView.swift
//  WikiSearch
//
//  Created by Teaualune Tseng on 2019/10/15.
//  Copyright © 2019 Zencher Co., Ltd. All rights reserved.
//

import SwiftUI

struct SearchView: View {

    @ObservedObject var model: SearchViewModel

    var body: some View {
        VStack {
            TextField("Search Wiki...", text: $model.searchText)
            if model.searchResult.count > 0 {
                List(model.searchResult) { result in
                    NavigationLink(destination: SearchResultDetail(searchResult: result)) {
                        Text(result.name)
                    }
                }
            } else {
                Spacer()
                Text("No Results")
            }
        }.padding()
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        let model = SearchViewModel(searchRepository: SearchRepository())
        model.searchResult.append(SearchResultItem(name: "Kaguya-sama: Love Is War", description: "Kaguya-sama: Love Is War (Japanese: かぐや様は告らせたい ～天才たちの恋愛頭脳戦～, Hepburn: Kaguya-sama wa Kokurasetai - Tensai-tachi no Ren'ai Zunōsen, transl.", url: "https://en.wikipedia.org/wiki/Kaguya-sama:_Love_Is_War"))
        return SearchView(model: model)
    }
}
