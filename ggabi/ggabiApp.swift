//
//  ggabiApp.swift
//  ggabi
//
//  Created by Jinwook on 8/16/24.
//

import SwiftUI

@main
struct ggabiApp: App {
    @StateObject private var favoriteManager = FavoritesManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(favoriteManager)
        }
    }
}
