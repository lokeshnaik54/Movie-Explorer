//
//  CustomBackButton.swift
//  Movie Explorer
//
//  Created by Gopal Kumar on 17/11/26.
//

import SwiftUI

struct BackButton: View {

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(.purple)
                .frame(width: 36, height: 36)
                .background(Color(.systemBackground), in: Circle())
                .overlay {
                    Circle().stroke(Color.purple.opacity(0.4), lineWidth: 1)
                }
                .shadow(color: .black.opacity(0.15), radius: 4, y: 2)
        }
        .buttonStyle(.plain)
    }
}

extension View {
    func customBackButton() -> some View {
        self
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton()
                }
            }
    }
}

struct CustomBackButton_Previews: PreviewProvider {
    static var previews: some View {
        BackButton()
    }
}
