//
//  CustomButton.swift
//  Movie Explorer
//
//  Created by Gopal Kumar on 17/11/26.
//

import SwiftUI

// MARK: - Shared look

struct CustomButton: View {

    let title: String
    var icon: String? = nil
    var isEnabled: Bool = true

    var body: some View {
        HStack(spacing: 8) {
            if let icon {
                Image(systemName: icon)
            }
            Text(title)
        }
        .font(.headline)
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(background)
        .clipShape(Capsule())
        .shadow(
            color: isEnabled ? Color.purple.opacity(0.4) : .clear,
            radius: 8,
            y: 4
        )
    }

    private var background: LinearGradient {
        let colors: [Color] = isEnabled
            ? [.purple, .indigo]
            : [.gray.opacity(0.5), .gray.opacity(0.5)]

        return LinearGradient(
            colors: colors,
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

struct PressableStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}


struct PrimaryButton: View {

    let title: String
    var icon: String? = nil
    var isEnabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            CustomButton(title: title, icon: icon, isEnabled: isEnabled)
        }
        .buttonStyle(PressableStyle())
        .disabled(!isEnabled)
    }
}


struct CustomBtn<Destination: View>: View {

    let title: String
    var icon: String? = nil
    var isEnabled: Bool = true
    @ViewBuilder let destination: () -> Destination

    var body: some View {
        NavigationLink {
            destination()
        } label: {
            CustomButton(title: title, icon: icon, isEnabled: isEnabled)
        }
        .buttonStyle(PressableStyle())
        .disabled(!isEnabled)
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            VStack(spacing: 20) {

                PrimaryButton(title: "Confirm Booking", icon: "checkmark.circle.fill") { }

                CustomBtn(title: "Book Tickets", icon: "ticket.fill") {
                    Text("Next Screen")
                }
                CustomBtn(title: "Select Seats", isEnabled: false) {
                    Text("Next Screen")
                }
            }
            .padding()
        }
    }
}
