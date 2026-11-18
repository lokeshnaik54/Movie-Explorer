import SwiftUI

struct HomeView: View {

    @StateObject private var viewModel = MovieViewModel()
    @Environment(\.openMenu) private var openMenu

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {

        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

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
                        .task {
                            await viewModel.loadMoreIfNeeded(current: movie)
                        }
                    }
                }

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
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    openMenu()
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .font(.title3)
                        .foregroundStyle(.purple)
                }
            }
        }
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
                Task { await viewModel.retry() }
            },
            secondaryTitle: "Cancel"
        )
        .task {
            if viewModel.movies.isEmpty {
                await viewModel.fetchMovies()
            }
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
        }
    }
}
