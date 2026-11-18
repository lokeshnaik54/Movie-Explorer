//
//  MovieDetailView.swift
//  Movie Explorer
//
//  Created by Gopal Kumar on 17/11/26.
//



import SwiftUI

struct MovieDetailView: View {
    
    let movie: Movie
    @State private var isUpdatingFavorite = false
    @EnvironmentObject var favoriteViewModel: FavoriteViewModel
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading, spacing: 20) {
                
                AsyncImage(
                    url: movie.posterPath.flatMap {
                        URL(string: "\(Networking.imageBaseURL)\($0)")
                    }
                ) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .overlay {
                            ProgressView()
                        }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 400)
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    HStack {
                        
                        Text(movie.title)
                            .font(.largeTitle.bold())
                        
                        Spacer()
                        
                        Button {
                            toggleFavoriteWithLoader()
                            
                        } label: {
                            
                            Image(
                                systemName: favoriteViewModel.isFavorite(movie: movie)
                                ? "heart.fill"
                                : "heart"
                            )
                            .font(.title2)
                            .foregroundStyle(.red)
                        }
                    }
                    
                    HStack {
                        
                        Label(
                            String(format: "%.1f", movie.voteAverage),
                            systemImage: "star.fill"
                        )
                        .foregroundStyle(.orange)
                        
                        Text(movie.releaseDate)
                            .foregroundStyle(.secondary)
                    }
                    
                    Text("Overview")
                        .font(.title2.bold())
                    
                    Text(movie.overview)
                        .font(.body)
                        .foregroundStyle(.secondary)
                    
                    // CHANGED: booking only for released movies
                    if movie.isReleased {
                        CustomBtn(title: "Book Tickets", destination: {
                            TheaterListView(movie: movie)     
                        })
                        .padding(.top, 15)
                    } else {
                        Label("Releases on \(movie.releaseDateText)", systemImage: "calendar")
                            .font(.subheadline.bold())
                            .foregroundStyle(.purple)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.purple.opacity(0.1), in: Capsule())
                            .padding(.top, 15)
                    }
                }
                .padding(.horizontal)

            }
            .navigationTitle("Movie Details")
            .navigationBarTitleDisplayMode(.inline)
            .customBackButton()
        }
    }
    
    private func toggleFavoriteWithLoader() {
        isUpdatingFavorite = true
        Task {
            try? await Task.sleep(nanoseconds: 600_000_000)
            favoriteViewModel.toggleFavorite(movie: movie)
            isUpdatingFavorite = false
        }
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(movie: Movie(
            id: 1,
            title: "Inception",
            overview: "A science fiction movie about dreams.",
            posterPath: nil,
            voteAverage: 8.8,
            releaseDate: "2010-07-16"
        ))
        .environmentObject(FavoriteViewModel())
    }
}

