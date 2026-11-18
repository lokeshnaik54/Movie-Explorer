//
//  CustomScarFold.swift
//  Movie Explorer
//
//  Created by Gopal Kumar on 18/11/26.
//

import SwiftUI

import SwiftUI

struct AuthScaffold<Content: View>: View {

    let icon: String
    let title: String
    let subtitle: String
    var onBack: (() -> Void)?
    let content: Content

    init(
        icon: String,
        title: String,
        subtitle: String,
        onBack: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.onBack = onBack
        self.content = content()
    }

    var body: some View {
        ZStack(alignment: .top) {

            LinearGradient(
                colors: [
                    Color(red: 0.30, green: 0.08, blue: 0.60),
                    .purple,
                    Color(red: 0.55, green: 0.28, blue: 0.92)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Decorative circles
            Circle()
                .fill(.white.opacity(0.08))
                .frame(width: 260)
                .offset(x: 140, y: -90)
            Circle()
                .fill(.white.opacity(0.06))
                .frame(width: 180)
                .offset(x: -150, y: 120)

            ScrollView {
                VStack(spacing: 26) {

                    header
                        .padding(.top, onBack == nil ? 50 : 20)

                    VStack(spacing: 18) {
                        content
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity)
                    .background(
                        Color(.systemBackground),
                        in: RoundedRectangle(cornerRadius: 30)
                    )
                    .shadow(color: .black.opacity(0.18), radius: 20, y: 10)
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 30)
            }
            .scrollDismissesKeyboard(.interactively)
            .scrollIndicators(.hidden)
        }
    }

    private var header: some View {
        VStack(spacing: 14) {

            if let onBack {
                HStack {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(width: 40, height: 40)
                            .background(.white.opacity(0.2), in: Circle())
                    }
                    Spacer()
                }
            }

            Image(systemName: icon)
                .font(.system(size: 34))
                .foregroundStyle(.white)
                .frame(width: 80, height: 80)
                .background(.white.opacity(0.18), in: Circle())
                .overlay(Circle().stroke(.white.opacity(0.35), lineWidth: 1))

            VStack(spacing: 6) {
                Text(title)
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
            }
        }
    }
}

struct AuthScaffold_Previews: PreviewProvider {
    static var previews: some View {
        AuthScaffold(
            icon: "film.stack",
            title: "Welcome Back",
            subtitle: "Log in to book your tickets"
        ) {
            Text("Preview content")
                .frame(maxWidth: .infinity, minHeight: 120)
        }
    }
}
