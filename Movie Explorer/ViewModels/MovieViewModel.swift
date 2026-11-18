//
//  HomeModelView.swift
//  Movie Explorer
//
//  Created by Gopal Kumar on 17/11/26.
//


import Foundation

@MainActor
class MovieViewModel: ObservableObject {

    // Popular
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var isLoadingMore = false

    // Search
    @Published var searchResults: [Movie] = []
    @Published var isSearching = false
    @Published var isSearchingMore = false

    @Published var errorMessage: String?

    private var currentPage = 0
    private var totalPages = 1
    private var searchPage = 0
    private var searchTotalPages = 1
    private var activeSearchQuery = ""
    private let maxPage = 500   // TMDB only serves up to page 500

    // MARK: - Popular

    func fetchMovies() async {
        guard movies.isEmpty, !isLoading else { return }
        isLoading = true
        await loadPopularPage(1)
        isLoading = false
    }

    func loadMoreIfNeeded(current movie: Movie) async {
        guard let last = movies.last, last.id == movie.id else { return }
        guard !isLoading, !isLoadingMore,
              currentPage < min(totalPages, maxPage) else { return }
        isLoadingMore = true
        await loadPopularPage(currentPage + 1)
        isLoadingMore = false
    }

    func retry() async {
        if movies.isEmpty {
            await fetchMovies()
        } else if !isLoadingMore {
            isLoadingMore = true
            await loadPopularPage(currentPage + 1)
            isLoadingMore = false
        }
    }

    private func loadPopularPage(_ page: Int) async {
        do {
            let response = try await APIService.shared.fetchPopularMovies(page: page)
            currentPage = response.page
            totalPages = response.totalPages
            let existing = Set(movies.map(\.id))
            movies += response.results.filter { !existing.contains($0.id) }
        } catch {
            if isCancellation(error) { return }
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Search

    func search(query: String) async {
        let text = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        activeSearchQuery = text
        searchResults = []
        searchPage = 0
        searchTotalPages = 1
        isSearchingMore = false

        isSearching = true
        await loadSearchPage(1, for: text)
        if activeSearchQuery == text { isSearching = false }
    }

    func loadMoreSearchIfNeeded(current movie: Movie) async {
        guard let last = searchResults.last, last.id == movie.id else { return }
        guard !isSearching, !isSearchingMore,
              searchPage < min(searchTotalPages, maxPage) else { return }

        let text = activeSearchQuery
        isSearchingMore = true
        await loadSearchPage(searchPage + 1, for: text)
        if activeSearchQuery == text { isSearchingMore = false }
    }

    private func loadSearchPage(_ page: Int, for text: String) async {
        do {
            let response = try await APIService.shared.searchMovies(query: text, page: page)
            guard text == activeSearchQuery else { return }   // ignore stale responses
            searchPage = response.page
            searchTotalPages = response.totalPages
            let existing = Set(searchResults.map(\.id))
            searchResults += response.results.filter { !existing.contains($0.id) }
        } catch {
            if isCancellation(error) { return }
            guard text == activeSearchQuery else { return }
            errorMessage = error.localizedDescription
        }
    }

    // A cancelled request (user kept typing, or the card scrolled away)
    // is not a real error, so don't show an alert for it.
    private func isCancellation(_ error: Error) -> Bool {
        error is CancellationError || (error as? URLError)?.code == .cancelled
    }
}

