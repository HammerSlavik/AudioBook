//
//  PlayerView.swift
//  AudioBook
//
//  Created by Sviatoslav Yakobchuk on 23.06.2024.
//

import SwiftUI
import ComposableArchitecture
import AVFoundation

var player: AVPlayer?

struct PlayerFeature: Reducer {
	struct State: Equatable {
		let book: Book
		var chapterIndex = 0
		var chapter: Book.Chapter {
			book.chapters[chapterIndex]
		}
		var isPlaying = false
		var progress: Double = 0
		var duration: Double = 0
	}
	enum Action {
		case togglePlayPauseTapped
		case play
		case pause
		case previousTapped
		case nextTapped
		case seekBackwardTapped
		case seekForwardTapped
		case chapterUpdated(Int)
		case progressUpdated(Double)
		case sliderUpdated(Double)
		case playbackFinished(Result<Void, Error>)
	}
	
	@Dependency(\.continuousClock) var clock
	private enum CancelID { case play }
	
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .togglePlayPauseTapped:
				if !state.isPlaying {
					return .send(.play)
				} else {
					return .send(.pause)
				}
			case .play:
				if player == nil {
					guard let url = Bundle.main.url(forResource: state.chapter.audioName, withExtension: "m4a") else {
						return .none
					}
					player = AVPlayer(url: url)
				}
				player!.play()
				state.isPlaying = true
				state.duration = player!.duration
				return .run { send in
					async let playbackObserving: Void = send(
						.playbackFinished(
							Result { await PlaybackDelegate().playbackFinished() }
						)
					)
					for await _ in self.clock.timer(interval: .milliseconds(500)) {
						await send(.progressUpdated(player!.currentTime))
					}
					await playbackObserving
				}
				.cancellable(id: CancelID.play, cancelInFlight: true)
			case .pause:
				guard player != nil else {
					return .none
				}
				player!.pause()
				state.isPlaying = false
				return .cancel(id: CancelID.play)
			case .previousTapped:
				guard state.chapterIndex - 1 >= 0 else {
					return .none
				}
				return .run{ [index = state.chapterIndex, isPlaying = state.isPlaying] send in
					if isPlaying {
						await send(.pause)
					}
					player = nil
					await send(.progressUpdated(0))
					await send(.chapterUpdated(index - 1))
					await send(.play)
				}
			case .nextTapped:
				guard state.chapterIndex + 1 <= state.book.chapters.count-1 else {
					return .none
				}
				return .run{ [index = state.chapterIndex, isPlaying = state.isPlaying] send in
					if isPlaying {
						await send(.pause)
					}
					player = nil
					await send(.progressUpdated(0))
					await send(.chapterUpdated(index + 1))
					await send(.play)
				}
			case let .chapterUpdated(index):
				state.chapterIndex = index
				return .none
			case .seekBackwardTapped:
				guard player?.currentItem != nil else {
					return .none
				}
				let newTime = player!.seek(delta: -5)
				return .send(.progressUpdated(newTime))
			case .seekForwardTapped:
				guard player?.currentItem != nil else {
					return .none
				}
				let newTime = player!.seek(delta: 10)
				return .send(.progressUpdated(newTime))
			case let .progressUpdated(progress):
				state.progress = progress
				return .none
			case let .sliderUpdated(progress):
				guard player?.currentItem != nil else {
					return .none
				}
				state.progress = progress
				player!.seek(to: progress)
				return .none
			case .playbackFinished:
				if state.chapterIndex + 1 <= state.book.chapters.count-1 {
					return .send(.nextTapped)
				}
				return .concatenate(
					.send(.pause),
					.send(.sliderUpdated(0)))
			}
		}
	}
}

extension AVPlayer {
	var currentTime: Double {
		currentTime().seconds
	}
	var duration: Double {
		currentItem!.asset.duration.seconds
	}
	func seek(to seconds: Double) {
		seek(to: CMTime(seconds: seconds, preferredTimescale: 1000))
	}
	func seek(delta: Double) -> Double {
		let newTime = min(max(0, currentTime + delta), duration)
		seek(to: CMTime(seconds: newTime, preferredTimescale: 1000))
		return newTime
	}
}


struct PlayerView: View {
	@Bindable var store: StoreOf<PlayerFeature>
	
    var body: some View {
		WithViewStore(self.store, observe: { $0 }) { viewStore in
			HStack(spacing: 5) {
				Text(timeDescription(seconds: viewStore.state.progress))
					.frame(width: 40, alignment: .leading)
				Slider(value: viewStore.binding(get: { $0.progress },
												send: { .sliderUpdated($0) }), in: 0...viewStore.state.duration)
				Text(timeDescription(seconds: viewStore.state.duration))
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
					viewStore.send(.previousTapped)
				} label: {
					Image(systemName: "backward.end.fill")
						.font(.system(size: 22))
				}
				.opacity(viewStore.chapterIndex == 0 ? 0.3 : 1)
				.disabled(viewStore.chapterIndex == 0)
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
					viewStore.send(.nextTapped)
				} label: {
					Image(systemName: "forward.end.fill")
						.font(.system(size: 22))
				}
				.opacity(viewStore.chapterIndex == viewStore.book.chapters.count-1 ? 0.3 : 1)
				.disabled(viewStore.chapterIndex == viewStore.book.chapters.count-1)
			}
			.frame(maxWidth: .infinity)
			.padding(.horizontal, 36)
			.foregroundStyle(.black)
			Spacer()
		}
    }
}

extension PlayerView {
	func timeDescription(seconds: Double) -> String {
		let min = Int(seconds / 60)
		let sec = Int(seconds) % 60
		return String(format: "%02d:%02d", min, sec)
	}
}

#Preview {
	PlayerView(store: Store(initialState: PlayerFeature.State(book: BookProvider().dummyBook())) {
		PlayerFeature()
			._printChanges()
	})
}
