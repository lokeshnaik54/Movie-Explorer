//
//  SideMenuView.swift
//  Movie Explorer
//
//  Created by Gopal Kumar on 18/11/26.
//

import SwiftUI

struct SideMenuView: View {

    @EnvironmentObject var auth: AuthViewModel
    @EnvironmentObject var favoriteViewModel: FavoriteViewModel
    @EnvironmentObject var historyViewModel: BookingHistoryViewModel

    let selectedTab: Int          // 0 Home, 1 Search, 2 Tickets
    let onHome: () -> Void
    let onSearch: () -> Void
    let onFavorites: () -> Void
    let onBookings: () -> Void
    let onLogout: () -> Void

    private var name: String { auth.currentUser?.name ?? "Guest" }
    private var email: String { auth.currentUser?.email ?? "" }

    private var initials: String {
        let letters = name.split(separator: " ")
            .prefix(2)
            .compactMap { $0.first }
            .map(String.init)
            .joined()
            .uppercased()
        return letters.isEmpty ? "?" : letters
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            profile
                .padding(.bottom, 22)

            statsRow
                .padding(.bottom, 26)

            Text("MENU")
                .font(.caption.bold())
                .tracking(1.5)
                .foregroundStyle(.white.opacity(0.6))
                .padding(.leading, 6)
                .padding(.bottom, 8)

            VStack(spacing: 6) {
                menuRow(icon: "house.fill", title: "Home",
                        isSelected: selectedTab == 0, action: onHome)

                menuRow(icon: "magnifyingglass", title: "Search",
                        isSelected: selectedTab == 1, action: onSearch)

                menuRow(icon: "heart.fill", title: "My Favorites",
                        badge: favoriteViewModel.favoriteMovies.count,
                        action: onFavorites)

                menuRow(icon: "ticket.fill", title: "My Bookings",
                        badge: historyViewModel.bookings.count,
                        isSelected: selectedTab == 2, action: onBookings)
            }

            Spacer()

            logoutButton
        }
        .padding(20)
        .frame(maxHeight: .infinity, alignment: .top)
        .background(background)
        .padding(.leading, 10)
        .padding(.vertical, 8)
        .shadow(color: .black.opacity(0.3), radius: 16, x: 6)
    }

    // MARK: - Background

    private var background: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.30, green: 0.08, blue: 0.60),
                    .purple,
                    Color(red: 0.50, green: 0.25, blue: 0.90)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Circle()
                .fill(.white.opacity(0.07))
                .frame(width: 240)
                .offset(x: 110, y: -260)

            Circle()
                .fill(.white.opacity(0.05))
                .frame(width: 200)
                .offset(x: -110, y: 280)
        }
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
    }

    // MARK: - Profile

    private var profile: some View {
        HStack(spacing: 14) {
            Text(initials)
                .font(.title2.bold())
                .foregroundStyle(.purple)
                .frame(width: 62, height: 62)
                .background(.white, in: Circle())
                .overlay(Circle().stroke(.white.opacity(0.4), lineWidth: 3))

            VStack(alignment: .leading, spacing: 3) {
                Text(name)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .lineLimit(1)

                Text(email)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.8))
                    .lineLimit(1)
            }

            Spacer(minLength: 0)
        }
        .padding(.top, 8)
    }

    private var statsRow: some View {
        HStack(spacing: 10) {
            statCard(value: favoriteViewModel.favoriteMovies.count,
                     title: "Favorites", icon: "heart.fill")
            statCard(value: historyViewModel.bookings.count,
                     title: "Bookings", icon: "ticket.fill")
        }
    }

    private func statCard(value: Int, title: String, icon: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundStyle(.white)
                .frame(width: 32, height: 32)
                .background(.white.opacity(0.18), in: Circle())

            VStack(alignment: .leading, spacing: 0) {
                Text("\(value)")
                    .font(.headline)
                    .foregroundStyle(.white)
                Text(title)
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.75))
            }
            Spacer(minLength: 0)
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .background(.white.opacity(0.12), in: RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Rows

    private func menuRow(
        icon: String,
        title: String,
        badge: Int? = nil,
        isSelected: Bool = false,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.body)
                    .foregroundStyle(isSelected ? Color.purple : .white)
                    .frame(width: 36, height: 36)
                    .background(
                        isSelected ? Color.white : Color.white.opacity(0.15),
                        in: RoundedRectangle(cornerRadius: 11)
                    )

                Text(title)
                    .fontWeight(isSelected ? .bold : .medium)
                    .foregroundStyle(.white)

                Spacer()

                if let badge, badge > 0 {
                    Text("\(badge)")
                        .font(.caption.bold())
                        .foregroundStyle(.purple)
                        .padding(.horizontal, 9)
                        .padding(.vertical, 3)
                        .background(.white, in: Capsule())
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 7)
            .background(
                isSelected ? Color.white.opacity(0.2) : Color.clear,
                in: RoundedRectangle(cornerRadius: 16)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var logoutButton: some View {
        Button(action: onLogout) {
            HStack(spacing: 10) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                Text("Log Out")
                    .fontWeight(.semibold)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(.white.opacity(0.18), in: Capsule())
            .overlay(Capsule().stroke(.white.opacity(0.35), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}

//struct SideMenuView_Previews: PreviewProvider {
//    static var previews: some View {
//        SideMenuView(onHome: {}, onFavorites: {}, onBookings: {}, onLogout: {})
//    }
//}
