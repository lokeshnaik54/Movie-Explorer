import SwiftUI
struct CustomLoaderView: View {

    @State private var isAnimating = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.35)
                .ignoresSafeArea()

            spinner
                .padding(28)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .onAppear { isAnimating = true }
    }

    private var spinner: some View {
        Circle()
            .trim(from: 0, to: 0.75)
            .stroke(
                Color.purple.opacity(0.6),
                style: StrokeStyle(lineWidth: 5, lineCap: .round)
            )
            .frame(width: 46, height: 46)
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .animation(
                .linear(duration: 0.9).repeatForever(autoreverses: false),
                value: isAnimating
            )
    }
}
