//
//  ContentView.swift
//  AudioBook
//
//  Created by Sviatoslav Yakobchuk on 23.06.2024.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
	let store: StoreOf<PlayerFeature>
	
    var body: some View {
		WithViewStore(self.store, observe: { $0 }) { viewStore in
			VStack(spacing: 0) {
				Image(viewStore.book.coverImageName)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.clipShape(.rect(cornerRadius: 8))
					.padding(20)
					.containerRelativeFrame(.vertical, { height, _ in height * 0.5 })
				Spacer()
					.frame(height: 20)
				Text("KEY POINT \(viewStore.chapterIndex+1) OF \(viewStore.book.chapters.count)")
					.font(.footnote)
					.fontWeight(.semibold)
					.foregroundStyle(.gray.opacity(0.95))
				Spacer()
					.frame(height: 10)
				Text(viewStore.chapter.title)
					.multilineTextAlignment(.center)
					.frame(height: 44)
//					.fixedSize(horizontal: false, vertical: true)
					.font(.callout)
					.fontWeight(.light)
					.padding(.horizontal, 10)
				Spacer()
					.frame(height: 20)
				PlayerView(store: store)
				.frame(maxHeight: .infinity)
				ModeView()
			}
			.padding(.horizontal, 20)
			.background(Color("ThemeBackground"))
		}
    }
}

#Preview {
	ContentView(store: Store(initialState: PlayerFeature.State(book: BookProvider().dummyBook())) {
		PlayerFeature()
			._printChanges()
	})
}
