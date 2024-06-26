//
//  PlaybackDelegate.swift
//  AudioBook
//
//  Created by Sviatoslav Yakobchuk on 26.06.2024.
//

import Foundation
import Combine

class PlaybackDelegate {
	var cancellable: AnyCancellable?
	
	func playbackFinished() async {
		_ = await AsyncStream<Bool> { continuation in
			cancellable = NotificationCenter.default.publisher(for: NSNotification.Name.AVPlayerItemDidPlayToEndTime).sink { notification in
				continuation.yield(true)
				continuation.finish()
			}
		}
		.first(where: { _ in true})
	}
	
	deinit {
		cancellable?.cancel()
	}
}
