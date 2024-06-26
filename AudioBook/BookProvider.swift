//
//  BookProvider.swift
//  AudioBook
//
//  Created by Sviatoslav Yakobchuk on 25.06.2024.
//

import Foundation

struct Book: Equatable {
	let coverImageName: String
	let chapters: [Chapter]
	
	struct Chapter: Equatable {
		let title: String
		let audioName: String
	}
}

struct BookProvider {
	func dummyBook() -> Book {
		Book(coverImageName: "BookBG", chapters: [.init(title: "Be open to the teachings of Abraham", audioName: "Chapter1"),
												  .init(title: "You create your own life experiences", audioName: "Chapter2"),
												  .init(title: "You have disconnected from the source energy", audioName: "Chapter3"),
												  .init(title: "The power of the Law of Attraction", audioName: "Chapter4"),
												  .init(title: "3 steps to manifesting your ideal life", audioName: "Chapter5")])
	}
}
