//
//  Extensions+ToolbarContent.swift
//  Marketplace
//
//  Created by Vitaliy Pupchenko on 14.09.2026.
//

import SwiftUI

extension ToolbarContent {
    @ToolbarContentBuilder
    func applySharedBackgroundVisibility() -> some ToolbarContent {
        if #available(iOS 26.0, *) {
            self.sharedBackgroundVisibility(.hidden)
        } else {
            self
        }
    }
}
