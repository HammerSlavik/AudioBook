//
//  PlayerView.swift
//  AudioBook
//
//  Created by Sviatoslav Yakobchuk on 23.06.2024.
//

import SwiftUI

struct PlayerView: View {
	@State private var progress = 0.3
    var body: some View {
		HStack(spacing: 5) {
			Text("00:28")
				.frame(width: 40, alignment: .leading)
			Slider(value: $progress, in: 0...1)
			Text("02:12")
				.frame(width: 40, alignment: .trailing)
		}
		.font(.footnote)
		.foregroundStyle(.gray)
		Button {
			
		} label: {
			Text("Speed x1")
				.frame(height: 32)
				.font(.footnote)
				.fontWeight(.medium)
				.padding(.horizontal, 10)
				.background(Color(white: 0.8).opacity(0.4))
				.foregroundStyle(.black)
				.clipShape(.rect(cornerRadius: 6))
		}
		Spacer()
		HStack {
			Button {
				
			} label: {
				Image(systemName: "backward.end.fill")
					.font(.system(size: 22))
			}
			Spacer()
			Button {
				
			} label: {
				Image(systemName: "gobackward.5")
					.font(.system(size: 28))
			}
			Spacer()
			Button {
				
			} label: {
				Image(systemName: "pause.fill")
					.font(.system(size: 42))
			}
			Spacer()
			Button {
				
			} label: {
				Image(systemName: "goforward.10")
					.font(.system(size: 28))
			}
			Spacer()
			Button {
				
			} label: {
				Image(systemName: "forward.end.fill")
					.font(.system(size: 22))
			}
		}
		.frame(maxWidth: .infinity)
		.padding(.horizontal, 36)
		.foregroundStyle(.black)
		Spacer()
    }
}

#Preview {
    PlayerView()
}
