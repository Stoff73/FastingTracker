import SwiftUI

extension View {
    @ViewBuilder
    func inlineNavigationBar() -> some View {
        #if os(iOS)
        self.navigationBarTitleDisplayMode(.inline)
        #else
        self
        #endif
    }

    @ViewBuilder
    func sheetDetents(_ detents: Set<PresentationDetent>) -> some View {
        #if os(iOS)
        self.presentationDetents(detents)
        #else
        self
        #endif
    }

    @ViewBuilder
    func phoneKeyboard() -> some View {
        #if os(iOS)
        self.keyboardType(.phonePad)
        #else
        self
        #endif
    }
}
