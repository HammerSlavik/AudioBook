//
//  ModeView.swift
//  AudioBook
//
//  Created by Sviatoslav Yakobchuk on 23.06.2024.
//

import SwiftUI

struct ModeView: View {
    var body: some View {
		Capsule()
			.frame(width: 112, height: 56)
			.foregroundStyle(.white)
			.overlay(
				Capsule()
					.strokeBorder(Color(white: 0.75), lineWidth: 1)
			)
    }
}

#Preview {
    ModeView()
}
