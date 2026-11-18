import SwiftUI

struct HomeView: View {

    @StateObject private var viewModel = MovieViewModel()
    @EnvironmentObject var favoriteViewModel: FavoriteViewModel

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {

        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                favoritesStrip

                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.movies) { movie in
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
                                .clipShape(RoundedRectangle(cornerRadius: 12))

                                Text(movie.title)
                                    .font(.headline)
                                    .lineLimit(1)

                                Text("⭐ \(movie.voteAverage, specifier: "%.1f")")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .buttonStyle(.plain)
                        // NEW: fires when this card appears; loads the next page if it's the last one
                        .task {
                            await viewModel.loadMoreIfNeeded(current: movie)
                        }
                    }
                }

                // NEW: bottom spinner while the next page loads
                if viewModel.isLoadingMore {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
            }
            .padding()
        }
        .navigationTitle("Popular Movies")
        .navigationBarBackButtonHidden(true)
        .favoritesToolbarButton()
        .overlay {
            if viewModel.isLoading {
                CustomLoaderView()
            }
        }
        .customAlert(
            isPresented: errorBinding,
            title: "Something went wrong",
            message: viewModel.errorMessage ?? "",
            primaryTitle: "Retry",
            primaryAction: {
                Task { await viewModel.retry() }   // CHANGED: was fetchMovies()
            },
            secondaryTitle: "Cancel"
        )
        .task {
            if viewModel.movies.isEmpty {
                await viewModel.fetchMovies()
            }
        }
    }

    // MARK: - Favorites strip

    @ViewBuilder
    private var favoritesStrip: some View {
        if !favoriteViewModel.favoriteMovies.isEmpty {
            VStack(alignment: .leading, spacing: 10) {

                HStack {
                    Text("Your Favorites")
                        .font(.title3.bold())

                    Spacer()

                    NavigationLink("See All") {
                        FavouriteView()
                    }
                    .font(.subheadline)
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 12) {
                        ForEach(favoriteViewModel.favoriteMovies) { movie in
                            NavigationLink {
                                MovieDetailView(movie: movie)
                            } label: {
                                favoriteCard(movie)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
    }

    private func favoriteCard(_ movie: Movie) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            AsyncImage(
                url: movie.posterPath.flatMap {
                    URL(string: "\(Networking.imageBaseURL)\($0)")
                }
            ) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Rectangle().fill(Color.gray.opacity(0.2))
            }
            .frame(width: 110, height: 160)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Text(movie.title)
                .font(.caption.bold())
                .lineLimit(1)
                .frame(width: 110, alignment: .leading)
        }
    }

    private var errorBinding: Binding<Bool> {
        Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HomeView()
                .environmentObject(FavoriteViewModel())
        }
    }
}
