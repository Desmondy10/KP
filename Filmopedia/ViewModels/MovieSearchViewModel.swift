//
//  MovieSearchViewModel.swift
//  Filmopedia
//
//  Created by iCodeWave Community on 22/05/25.
//

import Foundation
import SwiftUI

class MovieSearchViewModel: ObservableObject {
    @Published var movie: Movie?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let omdbService: OMDbService

    init(omdbService: OMDbService = OMDbService(apiKey: "7cb4a630")) { 
        self.omdbService = omdbService
    }

    @MainActor
    func searchMovie(title: String) async {
        isLoading = true
        errorMessage = nil
        movie = nil // Reset previous movie

        guard !title.isEmpty else {
            errorMessage = "Judul film tidak boleh kosong."
            isLoading = false
            return
        }

        do {
            let fetchedMovie = try await omdbService.fetchMovie(title: title)
            self.movie = fetchedMovie
        } catch let error as NetworkError {
            self.errorMessage = error.localizedDescription
        } catch {
            self.errorMessage = "Terjadi kesalahan tidak terduga: \(error.localizedDescription)"
        }
        isLoading = false
    }
}
