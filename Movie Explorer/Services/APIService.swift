import Foundation

class APIService {

    static let shared = APIService()

    private init() { }

    func fetchPopularMovies(page: Int = 1) async throws -> MovieResponse {
        try await request(
            path: "/movie/popular",
            queryItems: [
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "page", value: String(page))
            ]
        )
    }

    func searchMovies(query: String, page: Int = 1) async throws -> MovieResponse {
        try await request(
            path: "/search/movie",
            queryItems: [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "page", value: String(page))
            ]
        )
    }


    private func request(
        path: String,
        queryItems: [URLQueryItem]
    ) async throws -> MovieResponse {

        var components = URLComponents(string: "\(Networking.baseURL)\(path)")
        components?.queryItems = queryItems + [
            URLQueryItem(name: "api_key", value: Networking.apiKey)
        ]

        guard let url = components?.url else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let http = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard (200...299).contains(http.statusCode) else {
            let message = String(data: data, encoding: .utf8) ?? "No error details available"
            print("API Status Code:", http.statusCode)
            print("API Error:", message)

            throw NSError(
                domain: "TMDB API Error",
                code: http.statusCode,
                userInfo: [NSLocalizedDescriptionKey: message]
            )
        }

        return try JSONDecoder().decode(MovieResponse.self, from: data)
    }
}
