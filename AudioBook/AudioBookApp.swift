//
//  AudioBookApp.swift
//  AudioBook
//
//  Created by Sviatoslav Yakobchuk on 23.06.2024.
//

import SwiftUI
import ComposableArchitecture

@main
struct AudioBookApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(store: Store(initialState: PlayerFeature.State(book: BookProvider().dummyBook())) {
				PlayerFeature()
//			  ._printChanges()
			})
        }
    }
}
