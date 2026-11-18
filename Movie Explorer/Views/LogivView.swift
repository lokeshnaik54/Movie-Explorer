//
//  LogivView.swift
//  Movie Explorer
//
//  Created by Gopal Kumar on 18/11/26.
//

import SwiftUI

struct LoginView: View {

    @EnvironmentObject var auth: AuthViewModel

    @State private var email = ""
    @State private var password = ""

    var body: some View {
        NavigationStack {
            AuthScaffold(
                icon: "film.stack",
                title: "Welcome Back",
                subtitle: "Log in to book your tickets"
            ) {

                Text("Log In")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)

                CustomTextField(icon: "envelope", placeholder: "Email",
                                text: $email, keyboard: .emailAddress)

                CustomTextField(icon: "lock", placeholder: "Password",
                                text: $password, isSecure: true)

                PrimaryButton(title: "Log In") {
                    Task { await auth.login(email: email, password: password) }
                }
                .padding(.top, 6)

                HStack(spacing: 4) {
                    Text("Don't have an account?")
                        .foregroundStyle(.secondary)

                    NavigationLink("Sign Up") {
                        SignUpView()
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(.purple)
                }
                .font(.subheadline)
                .padding(.top, 4)
            }
            .navigationBarHidden(true)
        }
        // On the stack, so the loader and alert also cover the Sign Up screen
        .overlay {
            if auth.isLoading { CustomLoaderView() }
        }
        .customAlert(
            isPresented: errorBinding,
            title: "Something went wrong",
            message: auth.errorMessage ?? "",
            primaryTitle: "OK"
        )
    }

    private var errorBinding: Binding<Bool> {
        Binding(
            get: { auth.errorMessage != nil },
            set: { if !$0 { auth.errorMessage = nil } }
        )
    }
}

struct LogivView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthViewModel())
    }
}

