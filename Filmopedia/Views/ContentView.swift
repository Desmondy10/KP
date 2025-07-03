//
//  ContentView.swift
//  Filmopedia
//
//  Created by iCodeWave Community on 22/05/25.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MovieSearchViewModel()
    @State private var movieTitle: String = "Interstellar"
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Cari Film Favoritmu")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .padding(.bottom, 5)

                VStack(spacing: 5) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .font(.body)

                        TextField("Masukkan judul film", text: $movieTitle)
                            .focused($isTextFieldFocused)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)

                        if !movieTitle.isEmpty {
                            Button {
                                movieTitle = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                            .transition(.opacity)
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)

                    Rectangle()
                        .fill(isTextFieldFocused ? Color.blue : Color.gray.opacity(0.3))
                        .frame(height: 2)
                        .animation(.easeOut(duration: 0.2), value: isTextFieldFocused)
                }
                .padding(.horizontal)
                .padding(.bottom, 10)

                Button {
                    Task {
                        await viewModel.searchMovie(title: movieTitle)
                    }
                } label: {
                    Text("Cari Film")
                }

                .buttonStyle(ModernButtonStyle(isLoading: viewModel.isLoading))
                .padding(.horizontal)
                .disabled(viewModel.isLoading || movieTitle.isEmpty)

                if viewModel.isLoading {
                    ProgressView("Mencari film...")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal)
                } else if let movie = viewModel.movie {
                    MovieDetailView(movie: movie)
                        .transition(.slide)
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .padding(12)
                        .frame(maxWidth: .infinity)
                        .background(Color.red.opacity(0.8))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .shadow(color: Color.red.opacity(0.2), radius: 5, x: 0, y: 5)
                } else {
                    Spacer()
                    VStack {
                        Image(systemName: "film.stack.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray.opacity(0.6))
                            .padding(.bottom, 10)
                        Text("Mulai pencarianmu dengan mengetik judul film di atas.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }

                Spacer()
            }
            .navigationBarHidden(true)
            .background(Color.white.ignoresSafeArea())
            .onTapGesture {
                isTextFieldFocused = false
            }
        }
    }
							
    struct ModernButtonStyle: ButtonStyle {
        var isLoading: Bool = false

        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    Capsule()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.9), Color.blue]), startPoint: .leading, endPoint: .trailing))
                )
                .opacity(isLoading ? 0.6 : 1.0)
                .scaleEffect(configuration.isPressed && !isLoading ? 0.95 : 1.0)
                .shadow(color: Color.blue.opacity(0.4), radius: 15, x: 0, y: 10)
                .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
                .animation(.easeOut(duration: 0.2), value: isLoading)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
