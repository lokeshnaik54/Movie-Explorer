import SwiftUI

struct SearchView: View {

    @StateObject private var viewModel = MovieViewModel()
    @State private var query = ""
    @State private var isWaiting = false
    @FocusState private var isFocused: Bool

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    private var trimmedQuery: String {
        query.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var isSearchingMode: Bool {
        !trimmedQuery.isEmpty
    }

    private var displayedMovies: [Movie] {
        isSearchingMode ? viewModel.searchResults : viewModel.movies
    }

    private var showNoResults: Bool {
        isSearchingMode
        && !isWaiting
        && !viewModel.isSearching
        && viewModel.searchResults.isEmpty
    }

    // NEW
    private var isLoadingMore: Bool {
        isSearchingMode ? viewModel.isSearchingMore : viewModel.isLoadingMore
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            searchBar
            content
        }
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if viewModel.movies.isEmpty {
                await viewModel.fetchMovies()
            }
        }
        .task(id: query) {
            guard isSearchingMode else {
                isWaiting = false
                viewModel.searchResults = []
                return
            }
            isWaiting = true
            try? await Task.sleep(nanoseconds: 400_000_000)
            guard !Task.isCancelled else { return }
            isWaiting = false
            await viewModel.search(query: query)
        }
        .overlay {
            if viewModel.isLoading || viewModel.isSearching {
                CustomLoaderView()
            }
        }
        .customAlert(
            isPresented: errorBinding,
            title: "Something went wrong",
            message: viewModel.errorMessage ?? "",
            primaryTitle: "OK"
        )
    }

    // MARK: - Search bar

    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(isFocused ? .purple : .secondary)

            TextField("Search movies", text: $query)
                .focused($isFocused)
                .submitLabel(.search)
                .autocorrectionDisabled()

            if !query.isEmpty {
                Button {
                    query = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color(.systemBackground), in: Capsule())
        .overlay {
            Capsule()
                .stroke(
                    isFocused ? Color.purple : Color.purple.opacity(0.3),
                    lineWidth: isFocused ? 2 : 1
                )
        }
        .shadow(color: .black.opacity(0.08), radius: 6, y: 2)
        .padding(.horizontal)
        .padding(.vertical, 10)
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        if showNoResults {
            noResults
        } else {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    sectionHeader
                    grid

                    // NEW: bottom spinner
                    if isLoadingMore {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .scrollDismissesKeyboard(.immediately)
        }
    }

    private var sectionHeader: some View {
        HStack {
            Text(isSearchingMode ? "Results for \"\(trimmedQuery)\"" : "Popular Movies")
                .font(.title3.bold())
                .lineLimit(1)

            Spacer()
        }
    }

    private var grid: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(displayedMovies) { movie in
                NavigationLink {
                    MovieDetailView(movie: movie)
                } label: {
                    movieCard(movie)
                }
                .buttonStyle(.plain)
                .task {
                    if isSearchingMode {
                        await viewModel.loadMoreSearchIfNeeded(current: movie)
                    } else {
                        await viewModel.loadMoreIfNeeded(current: movie)
                    }
                }
            }
        }
    }

    private func movieCard(_ movie: Movie) -> some View {
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
                    .overlay { Image(systemName: "film") }
            }
            .frame(height: 220)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(alignment: .topTrailing) {
                ratingBadge(movie.voteAverage)
            }

            Text(movie.title)
                .font(.headline)
                .lineLimit(1)

            Text(String(movie.releaseDate.prefix(4)))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private func ratingBadge(_ rating: Double) -> some View {
        HStack(spacing: 3) {
            Image(systemName: "star.fill")
            Text(String(format: "%.1f", rating))
        }
        .font(.caption2.bold())
        .foregroundStyle(.white)
        .padding(.horizontal, 8)
        .padding(.vertical, 5)
        .background(.black.opacity(0.65), in: Capsule())
        .padding(8)
    }

    // MARK: - No results

    private var noResults: some View {
        VStack(spacing: 12) {
            Spacer()

            Image(systemName: "film.stack")
                .font(.system(size: 65))
                .foregroundStyle(.purple.opacity(0.7))

            Text("No movies found")
                .font(.title2.bold())

            Text("We couldn't find anything for \"\(trimmedQuery)\".\nTry a different name.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)

            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Error binding

    private var errorBinding: Binding<Bool> {
        Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SearchView()
                .environmentObject(FavoriteViewModel())
        }
    }
}
