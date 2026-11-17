//
//  HomeModelView.swift
//  Movie Explorer
//
//  Created by Gopal Kumar on 17/11/26.
//


import SwiftUI

@MainActor
class MovieViewModel: ObservableObject {

    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchResults: [Movie] = []
    @Published var isSearching = false
    

    func fetchMovies() async {

        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            let response = try await APIService.shared.fetchPopularMovies()

            movies = response.results
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func search(query: String) async {

        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else {
            searchResults = []
            return
        }

        isSearching = true
        defer { isSearching = false }

        do {
            let response = try await APIService.shared.searchMovies(query: trimmed)
            if Task.isCancelled { return }
            searchResults = response.results
        } catch {
            if (error as? URLError)?.code == .cancelled { return }
            errorMessage = error.localizedDescription
        }
    }
}

