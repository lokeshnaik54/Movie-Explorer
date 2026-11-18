//
//  SplashView.swift
//  Movie Explorer
//
//  Created by Gopal Kumar on 17/11/26.
//
import SwiftUI


struct SplashView: View {
    @State private var scale: CGFloat = 0.85
    @State private var opacity: Double = 0.0

    var body: some View {
        ZStack {
            
            Color(red: 0.004, green: 0.0, blue: 0.055)
                .ignoresSafeArea()

            Image("SplashView")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .scaleEffect(scale)
                .opacity(opacity)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.9)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
}


struct RootView: View {
    @State private var showSplash = true
    @StateObject private var auth = AuthViewModel()

    var body: some View {
        ZStack {
            if auth.isLoggedIn {
                MainView()
            } else {
                LoginView()
            }

            if showSplash {
                SplashView()
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .environmentObject(auth)
        .animation(.easeInOut(duration: 0.3), value: auth.isLoggedIn)
        .task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            withAnimation(.easeInOut(duration: 0.5)) {
                showSplash = false
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
