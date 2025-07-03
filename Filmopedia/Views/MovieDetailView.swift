//
//  MovieDetailView.swift
//  Filmopedia
//
//  Created by iCodeWave Community on 22/05/25.
//
import Foundation
import SwiftUI

struct MovieDetailView: View {
    let movie: Movie

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(movie.title)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.primary)

                    Text("\(movie.year) | \(movie.runtime) | \(movie.rated)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
                .padding(.bottom, 10)


                // Poster Film
                AsyncImage(url: URL(string: movie.poster)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: 400)
                        .cornerRadius(18) // Sudut lebih bulat
                        .shadow(color: Color.black.opacity(0.25), radius: 20, x: 0, y: 15) // Shadow lebih dramatis
                } placeholder: {
                    ProgressView()
                        .frame(width: 250, height: 350) // Ukuran placeholder lebih besar
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(18)
                }
                .padding(.bottom, 25)

                // Rating Section (IMDb & Metascore)
                HStack(spacing: 20) {
                    // IMDb Rating
                    VStack {
                        Text("IMDb Rating")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.orange)
                            Text(movie.imdbRating)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.orange)
                        }
                        Text("(\(movie.imdbVotes) Votes)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(10)

                    // Metascore
                    if movie.metascore != "N/A" {
                        VStack {
                            Text("Metascore")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(movie.metascore)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(metascoreColor(movie.metascore))
                                .frame(width: 40, height: 30)
                                .background(Capsule().fill(metascoreColor(movie.metascore).opacity(0.1)))
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(metascoreColor(movie.metascore).opacity(0.05))
                        .cornerRadius(10)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 20)

                // Sinopsis
                VStack(alignment: .leading, spacing: 8) {
                    Text("Plot")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(movie.plot)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineLimit(nil)
                }
                .padding(.horizontal, 5)
                .padding(.bottom, 20)

                // Info Umum
                VStack(alignment: .leading, spacing: 10) {
                    Text("Detail Film")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.bottom, 5)

                    DetailRow(label: "Genre", value: movie.genre)
                    Divider()
                    DetailRow(label: "Tanggal Rilis", value: movie.released)
                    Divider()
                    DetailRow(label: "Bahasa", value: movie.language)
                    Divider()
                    DetailRow(label: "Negara", value: movie.country)
                    Divider()
                    DetailRow(label: "Penghargaan", value: movie.awards)
                }
                .padding(.bottom, 20)

                // Info Crew
                VStack(alignment: .leading, spacing: 10) {
                    Text("Pemeran & Kru")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.bottom, 5)

                    DetailRow(label: "Sutradara", value: movie.director)
                    Divider()
                    DetailRow(label: "Penulis", value: movie.writer)
                    Divider()
                    DetailRow(label: "Aktor", value: movie.actors)
                }
                .padding(.bottom, 20)
                
                // External Ratings
                if !movie.ratings.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Rating Lain")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.bottom, 5)
                        ForEach(movie.ratings, id: \.source) { rating in
                            DetailRow(label: rating.source, value: rating.value)
                            if rating.source != movie.ratings.last?.source {
                                Divider()
                            }
                        }
                    }
                    .padding(.bottom, 20)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Informasi Tambahan")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.bottom, 5)

                    if let dvd = movie.dvd, dvd != "N/A" {
                        DetailRow(label: "Tanggal DVD", value: dvd)
                        Divider()
                    }
                    if let boxOffice = movie.boxOffice, boxOffice != "N/A" {
                        DetailRow(label: "Box Office", value: boxOffice)
                        Divider()
                    }
                    if let production = movie.production, production != "N/A" {
                        DetailRow(label: "Produksi", value: production)
                        Divider()
                    }
                    if let website = movie.website, website != "N/A" {
                        DetailRow(label: "Situs Web Resmi", value: website)
                    }
                }
                .padding(.bottom, 20)

            }
            .padding()
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
        .background(Color.white.ignoresSafeArea())
    }

    // Helper untuk warna Metascore
    private func metascoreColor(_ score: String) -> Color {
        guard let s = Int(score) else { return .gray }
        if s >= 61 { return .green }
        if s >= 40 { return .yellow }
        return .red
    }
}

// Helper View untuk baris detail (tetap sama)
struct DetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .top) {
            Text("\(label):")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .frame(width: 140, alignment: .leading)
            Text(value)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
        }
    }
}

// Preview Provider
struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(movie: Movie(
            title: "Interstellar",
            year: "2014",
            rated: "PG-13",
            released: "07 Nov 2014",
            runtime: "169 min",
            genre: "Adventure, Drama, Sci-Fi",
            director: "Christopher Nolan",
            writer: "Jonathan Nolan, Christopher Nolan",
            actors: "Matthew McConaughey, Anne Hathaway, Jessica Chastain",
            plot: "A team of explorers travel through a wormhole in space in an attempt to ensure humanity's survival.",
            language: "English",
            country: "USA, UK, Canada",
            awards: "Won 1 Oscar. Another 44 wins & 148 nominations.",
            poster: "https://m.media-amazon.com/images/M/MV5BZjdkOTU3MDktN2IxOS00NDlkLWE1NDctYTc3NjlkNTZmY2MyXkEyXkFqcGdeQXVyNjgwMjkwNzQ@._V1_SX300.jpg",
            ratings: [
                Rating(source: "Internet Movie Database", value: "8.6/10"),
                Rating(source: "Rotten Tomatoes", value: "72%"),
                Rating(source: "Metacritic", value: "74/100")
            ],
            metascore: "74",
            imdbRating: "8.6",
            imdbVotes: "2,000,000",
            imdbID: "tt0816692",
            type: "movie",
            dvd: "31 Mar 2015",
            boxOffice: "$188,020,017",
            production: "Paramount Pictures, Warner Bros. Pictures, Legendary Entertainment",
            website: "http://www.interstellarmovie.com/",
            response: "True",
            error: nil
        ))
    }
}
