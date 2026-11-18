//
//  CustomTextField.swift
//  Movie Explorer
//
//  Created by Gopal Kumar on 18/11/26.
//

import SwiftUI

struct CustomTextField: View {

    let icon: String
    let placeholder: String
    @Binding var text: String
    var isSecure = false
    var keyboard: UIKeyboardType = .default

    @State private var reveal = false

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundStyle(.secondary)
                .frame(width: 20)

            Group {
                if isSecure && !reveal {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                        .keyboardType(keyboard)
                }
            }
            .textInputAutocapitalization(keyboard == .emailAddress || isSecure ? .never : .words)
            .autocorrectionDisabled()

            if isSecure {
                Button {
                    reveal.toggle()
                } label: {
                    Image(systemName: reveal ? "eye" : "eye.slash")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color(.systemBackground), in: Capsule())
        .overlay {
            Capsule().stroke(Color.purple.opacity(0.3), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.06), radius: 5, y: 2)
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(icon: "", placeholder: "", text: .constant(""))
    }
}
