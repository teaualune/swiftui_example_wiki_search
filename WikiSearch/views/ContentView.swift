//
//  ContentView.swift
//  WikiSearch
//
//  Created by Teaualune Tseng on 2019/10/15.
//  Copyright © 2019 Zencher Co., Ltd. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var model = SearchViewModel()

    var body: some View {
        NavigationView {
            SearchView(model: model).navigationBarTitle(Text("Wiki Search"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
