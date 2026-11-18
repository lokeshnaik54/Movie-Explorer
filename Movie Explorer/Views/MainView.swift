import SwiftUI


private struct GoHomeKey: EnvironmentKey {
    static let defaultValue: () -> Void = { }
}

extension EnvironmentValues {
    var goHome: () -> Void {
        get { self[GoHomeKey.self] }
        set { self[GoHomeKey.self] = newValue }
    }
}

struct MainView: View {
    
    @State private var isSelected = 0
    @State private var stackID = UUID()
    @StateObject private var historyViewModel = BookingHistoryViewModel()
    @StateObject private var favoriteViewModel = FavoriteViewModel()
    
    var body: some View {
        Group {
            if isSelected == 0 {
                tabPage { HomeView() }
            } else if isSelected == 1 {
                tabPage { SearchView() }
            } else {
                tabPage { BookingHistoryView() }
            }
        }
        .environmentObject(favoriteViewModel)
        .environmentObject(historyViewModel)
        .environment(\.goHome, goHome)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func goHome() {
        isSelected = 0
        stackID = UUID()
    }
    
    private func tabPage<Content: View>(
        @ViewBuilder _ content: () -> Content
    ) -> some View {
        NavigationStack {
            content()
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    customTabBar
                }
        }
        .id(stackID)
    }
    
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
            
            withAnimation(.spring(blendDuration: 0.3)) {
                isSelected = tag
            }
            
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
    }
}
