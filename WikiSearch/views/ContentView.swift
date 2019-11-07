//
//  ContentView.swift
//  WikiSearch
//
//  Created by Teaualune Tseng on 2019/10/15.
//  Copyright © 2019 Zencher Co., Ltd. All rights reserved.
//

import UIKit
import SwiftUI

struct ContentView: View {

    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }

    var body: some View {
        let nav = NavigationView {
            SearchView().navigationBarTitle(Text("Wiki Search"))
        }
        .padding()
        if idiom == .pad {
            return AnyView(nav.navigationViewStyle(DoubleColumnNavigationViewStyle()))
        }
        return AnyView(nav.navigationViewStyle(StackNavigationViewStyle()))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(SearchViewModel(searchRepository: SearchRepository()))
    }
}
