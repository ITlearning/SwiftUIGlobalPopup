//
//  PopupView.swift
//  PopupTest
//
//  Created by Tabber on 2022/12/26.
//

import SwiftUI

struct PopupView<Content: View>: View {
    var content: () -> Content
    var body: some View {
        Group(content: content)
    }
}
