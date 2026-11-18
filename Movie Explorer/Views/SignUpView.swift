//
//  SignUpView.swift
//  Movie Explorer
//
//  Created by Gopal Kumar on 18/11/26.
//

import SwiftUI

struct SignUpView: View {

    @EnvironmentObject var auth: AuthViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirm = ""

    // 0 = too short ... 3 = strong
    private var strength: Int {
        var score = 0
        if password.count >= 6 { score += 1 }
        if password.count >= 10 { score += 1 }
        let hasLetter = password.rangeOfCharacter(from: .letters) != nil
        let hasDigit = password.rangeOfCharacter(from: .decimalDigits) != nil
        if hasLetter && hasDigit { score += 1 }
        return score
    }

    private let strengthLabels = ["Too short", "Weak", "Good", "Strong"]
    private let strengthColors: [Color] = [.red, .orange, .yellow, .green]

    var body: some View {
        AuthScaffold(
            icon: "person.crop.circle.badge.plus",
            title: "Create Account",
            subtitle: "Sign up to start booking movies",
            onBack: { dismiss() }
        ) {

            CustomTextField(icon: "person", placeholder: "Full name", text: $name)

            CustomTextField(icon: "envelope", placeholder: "Email",
                            text: $email, keyboard: .emailAddress)

            VStack(alignment: .leading, spacing: 8) {
                CustomTextField(icon: "lock", placeholder: "Password (min 6 characters)",
                                text: $password, isSecure: true)

                if !password.isEmpty {
                    strengthMeter
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                CustomTextField(icon: "lock.rotation", placeholder: "Confirm password",
                                text: $confirm, isSecure: true)

                if !confirm.isEmpty && confirm != password {
                    Text("Passwords don't match")
                        .font(.caption)
                        .foregroundStyle(.red)
                        .padding(.leading, 16)
                }
            }

            PrimaryButton(title: "Sign Up") {
                Task {
                    await auth.signUp(
                        name: name,
                        email: email,
                        password: password,
                        confirm: confirm
                    )
                }
            }
            .padding(.top, 6)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }

    private var strengthMeter: some View {
        HStack(spacing: 6) {
            ForEach(1...3, id: \.self) { level in
                Capsule()
                    .fill(level <= strength ? strengthColors[strength] : Color.gray.opacity(0.25))
                    .frame(height: 5)
            }

            Text(strengthLabels[strength])
                .font(.caption.bold())
                .foregroundStyle(strengthColors[strength])
                .frame(width: 60, alignment: .trailing)
        }
        .padding(.horizontal, 16)
        .animation(.easeInOut(duration: 0.2), value: strength)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignUpView()
                .environmentObject(AuthViewModel())
        }
    }
}

