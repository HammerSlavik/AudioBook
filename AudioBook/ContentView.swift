//
//  ContentView.swift
//  AudioBook
//
//  Created by Sviatoslav Yakobchuk on 23.06.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
		VStack(spacing: 0) {
            Image("BookBG")
				.resizable()
				.aspectRatio(contentMode: .fit)
				.clipShape(.rect(cornerRadius: 8))
				.padding(20)
				.containerRelativeFrame(.vertical, { height, _ in height * 0.5 })
			Spacer()
				.frame(height: 20)
            Text("KEY POINT 2 OF 10")
				.font(.footnote)
				.fontWeight(.semibold)
				.foregroundStyle(.gray.opacity(0.95))
			Spacer()
				.frame(height: 10)
			Text("Design is not how a thing looks, but how it works")
				.multilineTextAlignment(.center)
				.fixedSize(horizontal: false, vertical: true)
				.font(.callout)
				.fontWeight(.light)
				.padding(.horizontal, 10)
			Spacer()
				.frame(height: 20)
			PlayerView()
				.frame(maxHeight: .infinity)
			ModeView()
        }
		.padding(.horizontal, 20)
		.background(Color("ThemeBackground"))
    }
}

#Preview {
    ContentView()
}
