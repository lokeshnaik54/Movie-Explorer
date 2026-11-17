//
//  ProfileView.swift
//  Movie Explorer
//
//  Created by Gopal Kumar on 03/11/26.
//



import SwiftUI

struct FavouriteView: View {

    @State private var showClearAlert = false
    @State private var isClearing = false
    @EnvironmentObject var favoriteViewModel: FavoriteViewModel

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {

        VStack {

            if favoriteViewModel.favoriteMovies.isEmpty {

                Spacer()

                Image(systemName: "heart")
                    .font(.system(size: 45))
                    .foregroundStyle(.secondary)

                Text("No Favorites Yet")
                    .font(.title2.bold())

                Text("Add your favorite movies to see them here.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Spacer()

            } else {

                ScrollView {

                    LazyVGrid(columns: columns, spacing: 20) {

                        ForEach(favoriteViewModel.favoriteMovies) { movie in

                            NavigationLink {

                                MovieDetailView(movie: movie)

                            } label: {

                                VStack(alignment: .leading, spacing: 8) {

                                    AsyncImage(
                                        url: movie.posterPath.flatMap {
                                            URL(string: "\(Networking.imageBaseURL)\($0)")
                                        }
                                    ) { image in

                                        image
                                            .resizable()
                                            .scaledToFill()

                                    } placeholder: {

                                        Rectangle()
                                            .fill(Color.gray.opacity(0.2))
                                            .overlay {
                                                ProgressView()
                                            }
                                    }
                                    .frame(height: 220)
                                    .frame(maxWidth: .infinity)
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 12)
                                    )

                                    Text(movie.title)
                                        .font(.headline)
                                        .lineLimit(1)

                                    Label(
                                        String(format: "%.1f", movie.voteAverage),
                                        systemImage: "star.fill"
                                    )
                                    .font(.subheadline)
                                    .foregroundStyle(.orange)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .customBackButton()
        .navigationTitle("My Favorites")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if !favoriteViewModel.favoriteMovies.isEmpty {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear All") {
                        showClearAlert = true
                    }
                    .foregroundStyle(.red)
                }
            }
        }
        .overlay {
            if isClearing {
                CustomLoaderView()
            }
        }
        .customAlert(
            isPresented: $showClearAlert,
            icon: "trash.fill",
            iconColor: .red,
            title: "Clear all favorites?",
            message: "This will remove all \(favoriteViewModel.favoriteMovies.count) movies from your list.",
            primaryTitle: "Clear",
            primaryAction: { clearFavorites() },
            secondaryTitle: "Cancel"
        )
    }
    private func clearFavorites() {
        isClearing = true
        Task {
            try? await Task.sleep(nanoseconds: 800_000_000)
            favoriteViewModel.favoriteMovies.removeAll()
            isClearing = false
        }
    }
}

struct FavouriteView_Previews: PreviewProvider {

    static var previews: some View {

        NavigationView {
            FavouriteView()
                .environmentObject(FavoriteViewModel())
        }
    }
}


struct FavoritesView_Previews: PreviewProvider {

    static var previews: some View {

        NavigationView {
            FavouriteView()
                .environmentObject(FavoriteViewModel())
        }
    }
}

