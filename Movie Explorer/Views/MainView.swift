import SwiftUI

// Lets any screen inside the app jump back to the Home tab
private struct GoHomeKey: EnvironmentKey {
    static let defaultValue: () -> Void = { }
}

// Lets any screen open the side menu
private struct OpenMenuKey: EnvironmentKey {
    static let defaultValue: () -> Void = { }
}

extension EnvironmentValues {
    var goHome: () -> Void {
        get { self[GoHomeKey.self] }
        set { self[GoHomeKey.self] = newValue }
    }

    var openMenu: () -> Void {
        get { self[OpenMenuKey.self] }
        set { self[OpenMenuKey.self] = newValue }
    }
}

struct MainView: View {

    @State private var isSelected = 0
    @State private var stackID = UUID()
    @State private var showMenu = false
    @State private var showFavorites = false
    @State private var showLogoutAlert = false

    @StateObject private var historyViewModel = BookingHistoryViewModel()
    @StateObject private var favoriteViewModel = FavoriteViewModel()
    @EnvironmentObject var auth: AuthViewModel

    var body: some View {
        ZStack(alignment: .leading) {

            Group {
                if isSelected == 0 {
                    tabPage { HomeView() }
                } else if isSelected == 1 {
                    tabPage { SearchView() }
                } else {
                    tabPage { BookingHistoryView() }
                }
            }

            if showMenu {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture { showMenu = false }
                    .transition(.opacity)
                    .zIndex(1)

                SideMenuView(
                    selectedTab: isSelected,
                    onHome: {
                        showMenu = false
                        goHome()
                    },
                    onSearch: {
                        showMenu = false
                        select(1)
                    },
                    onFavorites: {
                        showMenu = false
                        showFavorites = true          // pushes the screen
                    },
                    onBookings: {
                        showMenu = false
                        select(2)
                    },
                    onLogout: {
                        showMenu = false
                        showLogoutAlert = true
                    }
                )
                .frame(width: 320)
                .transition(.move(edge: .leading))
                .gesture(
                    DragGesture().onEnded { value in
                        if value.translation.width < -60 { showMenu = false }
                    }
                )
                .zIndex(2)
            }
        }
        .environmentObject(favoriteViewModel)
        .environmentObject(historyViewModel)
        .environment(\.goHome, goHome)
        .environment(\.openMenu, openMenu)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(.easeInOut(duration: 0.28), value: showMenu)
        .customAlert(
            isPresented: $showLogoutAlert,
            icon: "rectangle.portrait.and.arrow.right",
            iconColor: .red,
            title: "Log out?",
            message: "You'll need to log in again to book tickets.",
            primaryTitle: "Log Out",
            primaryAction: { auth.logout() },
            secondaryTitle: "Cancel"
        )
    }

    // MARK: - Actions

    private func openMenu() {
        showMenu = true
    }

    /// Switch tab and make sure a pushed Favorites screen doesn't reopen on the new tab
    private func select(_ tab: Int) {
        showFavorites = false
        withAnimation(.spring(blendDuration: 0.3)) {
            isSelected = tab
        }
    }

    private func goHome() {
        showFavorites = false
        isSelected = 0
        stackID = UUID()
    }

    // MARK: - Tab page

    private func tabPage<Content: View>(
        @ViewBuilder _ content: () -> Content
    ) -> some View {
        NavigationStack {
            content()
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    customTabBar
                }
                .navigationDestination(isPresented: $showFavorites) {
                    FavouriteView()
                }
        }
        .id(stackID)
    }

    // MARK: - Tab bar

    private var customTabBar: some View {

        HStack {
            tabButton(title: "Home", icon: "house.fill", tag: 0)
            tabButton(title: "Search", icon: "magnifyingglass", tag: 1)
            tabButton(title: "Tickets", icon: "ticket.fill", tag: 2)
        }
        .padding(9)
        .background(
            Color(.systemBackground),
            in: Capsule()
        )
        .overlay {
            Capsule()
                .stroke(Color.purple, lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.2), radius: 8, y: 2)
        .padding(.horizontal, 15)
        .padding(.vertical, 5)
    }

    private func tabButton(
        title: String,
        icon: String,
        tag: Int
    ) -> some View {

        Button {
            select(tag)
        } label: {

            HStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.system(size: 15))

                Text(title)
                    .font(.system(size: 15))
            }
            .foregroundColor(
                isSelected == tag ? .purple : .gray
            )
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background {
                if isSelected == tag {
                    Capsule()
                        .fill(Color.purple.opacity(0.1))
                }
            }
            .overlay {
                if isSelected == tag {
                    Capsule()
                        .stroke(Color.purple, lineWidth: 2)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(AuthViewModel())
    }
}
