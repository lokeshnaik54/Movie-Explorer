
import SwiftUI

class FavoriteViewModel: ObservableObject {

    @Published var favoriteMovies: [Movie] = [] {
        didSet {
            saveFavorites()
        }
    }

    private let favoritesKey = "SavedFavoriteMovies"

    init() {
        loadFavorites()
    }


    func toggleFavorite(movie: Movie) {

        if isFavorite(movie: movie) {

            favoriteMovies.removeAll {
                $0.id == movie.id
            }

        } else {

            favoriteMovies.append(movie)
        }
    }



    func isFavorite(movie: Movie) -> Bool {

        favoriteMovies.contains {
            $0.id == movie.id
        }
    }


    private func saveFavorites() {

        do {

            let data = try JSONEncoder().encode(favoriteMovies)

            UserDefaults.standard.set(data, forKey: favoritesKey)

        } catch {

            print("Error saving favorites: \(error.localizedDescription)")
        }
    }


    private func loadFavorites() {

        guard let data = UserDefaults.standard.data(forKey: favoritesKey) else {
            return
        }

        do {

            favoriteMovies = try JSONDecoder().decode(
                [Movie].self,
                from: data
            )

        } catch {

            print("Error loading favorites: \(error.localizedDescription)")
        }
    }
}
