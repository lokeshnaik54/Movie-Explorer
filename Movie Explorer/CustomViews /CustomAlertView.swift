//
//  CustomAlertView.swift
//  Movie Explorer
//
//  Created by Gopal Kumar on 17/11/26.
//

import SwiftUI

struct CustomAlertView: View {

    let icon: String
    let iconColor: Color
    let title: String
    let message: String
    let primaryTitle: String
    let primaryAction: () -> Void
    var secondaryTitle: String? = nil
    var secondaryAction: (() -> Void)? = nil

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            card
        }
    }

    private var card: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundStyle(iconColor)

            Text(title)
                .font(.title3.bold())

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            buttons
        }
        .padding(24)
        .frame(maxWidth: 320)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 20)
    }

    private var buttons: some View {
        HStack(spacing: 12) {
            if let secondaryTitle {
                Button(secondaryTitle) {
                    secondaryAction?()
                }
                .font(.headline)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Button(primaryTitle) {
                primaryAction()
            }
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color.purple)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}


extension View {

    func customAlert(
        isPresented: Binding<Bool>,
        icon: String = "exclamationmark.triangle.fill",
        iconColor: Color = .orange,
        title: String,
        message: String,
        primaryTitle: String = "OK",
        primaryAction: @escaping () -> Void = {},
        secondaryTitle: String? = nil,
        secondaryAction: @escaping () -> Void = {}
    ) -> some View {
        self.overlay {
            if isPresented.wrappedValue {
                CustomAlertView(
                    icon: icon,
                    iconColor: iconColor,
                    title: title,
                    message: message,
                    primaryTitle: primaryTitle,
                    primaryAction: {
                        isPresented.wrappedValue = false
                        primaryAction()
                    },
                    secondaryTitle: secondaryTitle,
                    secondaryAction: {
                        isPresented.wrappedValue = false
                        secondaryAction()
                    }
                )
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isPresented.wrappedValue)
    }
}

struct CustomAlertView_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlertView(icon: "", iconColor: Color.green, title: "", message: "", primaryTitle: "", primaryAction: {
            
        })
    }
}
