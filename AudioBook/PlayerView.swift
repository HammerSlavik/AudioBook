//
//  PlayerView.swift
//  AudioBook
//
//  Created by Sviatoslav Yakobchuk on 23.06.2024.
//

import SwiftUI
import ComposableArchitecture

struct PlayerFeature: Reducer {
	struct State: Equatable {
		var isPlaying = false
	}
	enum Action {
		case togglePlayPauseTapped
		case endBackwardTapped
		case endForwardTapped
		case seekBackwardTapped
		case seekForwardTapped
	}
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .togglePlayPauseTapped:
				state.isPlaying.toggle()
				return .none
			case .endBackwardTapped:
				return .none
			case .endForwardTapped:
				return .none
			case .seekBackwardTapped:
				return .none
			case .seekForwardTapped:
				return .none
			}
		}
	}
}

struct PlayerView: View {
	let store: StoreOf<PlayerFeature>
	
	@State private var progress = 0.3
    var body: some View {
		WithViewStore(self.store, observe: { $0 }) { viewStore in
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
					viewStore.send(.endBackwardTapped)
				} label: {
					Image(systemName: "backward.end.fill")
						.font(.system(size: 22))
				}
				Spacer()
				Button {
					viewStore.send(.seekBackwardTapped)
				} label: {
					Image(systemName: "gobackward.5")
						.font(.system(size: 28))
				}
				Spacer()
				Button {
					viewStore.send(.togglePlayPauseTapped)
				} label: {
					Image(systemName: viewStore.isPlaying ? "pause.fill" : "play.fill")
						.font(.system(size: 42))
						.frame(width: 38)
				}
				Spacer()
				Button {
					viewStore.send(.seekForwardTapped)
				} label: {
					Image(systemName: "goforward.10")
						.font(.system(size: 28))
				}
				Spacer()
				Button {
					viewStore.send(.endForwardTapped)
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
}

#Preview {
	PlayerView(store: Store(initialState: PlayerFeature.State()) {
		PlayerFeature()
			._printChanges()
	})
}
