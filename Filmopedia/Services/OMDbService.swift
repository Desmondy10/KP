//
//  OMDbService.swift
//  Filmopedia
//
//  Created by iCodeWave Community on 22/05/25.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
    case apiError(String) // Untuk error spesifik dari API (misal: "Movie not found!")

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL tidak valid."
        case .networkError(let error):
            return "Kesalahan jaringan: \(error.localizedDescription)"
        case .invalidResponse:
            return "Respons server tidak valid."
        case .decodingError(let error):
            return "Gagal mengurai data: \(error.localizedDescription)"
        case .apiError(let message):
            return "Kesalahan API: \(message)"
        }
    }
}

class OMDbService {
    private let apiKey: String
    private let baseURL: String

    init(apiKey: String, baseURL: String = "https://www.omdbapi.com/") {
        self.apiKey = apiKey
        self.baseURL = baseURL
    }

    func fetchMovie(title: String) async throws -> Movie {
        guard let encodedTitle = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw NetworkError.invalidURL
        }

        let urlString = "\(baseURL)?apikey=\(apiKey)&t=\(encodedTitle)"
        print("URL Permintaan: \(urlString)")

        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            print(String(data: data, encoding: .utf8))

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw NetworkError.invalidResponse
            }

            let decodedMovie = try JSONDecoder().decode(Movie.self, from: data)

            if decodedMovie.response == "True" {
                return decodedMovie
            } else {
                // Handle API-specific errors (e.g., "Movie not found!")
                if let errorMessage = decodedMovie.error {
                    throw NetworkError.apiError(errorMessage)
                } else {
                    throw NetworkError.apiError("Film tidak ditemukan atau ada kesalahan lain dari API.")
                }
            }
        } catch let decodingError as DecodingError {
            // Print raw JSON for detailed debugging if decoding fails
            if let (data, _) = try? await URLSession.shared.data(from: url),
               let rawJSON = String(data: data, encoding: .utf8) {
                print("Raw JSON for decoding error: \(rawJSON)")
            }
            throw NetworkError.decodingError(decodingError)
        } catch {
            throw NetworkError.networkError(error)
        }
    }
}
