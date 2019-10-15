//
//  SearchResultDetail.swift
//  WikiSearch
//
//  Created by Teaualune Tseng on 2019/10/15.
//  Copyright © 2019 Zencher Co., Ltd. All rights reserved.
//

import SwiftUI

struct SearchResultDetail: View {

    var searchResult: SearchResultItem

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(searchResult.name)
            Text(searchResult.description)
            Text(searchResult.url)
        }.padding().navigationBarTitle(Text(searchResult.name))
    }
}

struct SearchResultDetail_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultDetail(searchResult: SearchResultItem(name: "Kaguya-sama: Love Is War", description: "Kaguya-sama: Love Is War (Japanese: かぐや様は告らせたい ～天才たちの恋愛頭脳戦～, Hepburn: Kaguya-sama wa Kokurasetai - Tensai-tachi no Ren'ai Zunōsen, transl.", url: "https://en.wikipedia.org/wiki/Kaguya-sama:_Love_Is_War"))
    }
}
