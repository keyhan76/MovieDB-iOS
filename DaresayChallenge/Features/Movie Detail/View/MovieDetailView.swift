//
//  MovieDetailView.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-09-07.
//

import SwiftUI

struct MovieDetailView: View {
    
    @ObservedObject var viewModel: MovieDetailViewModel
    
    var body: some View {
        GeometryReader { metrics in
            VStack(spacing: 0) {
                
                ImageView(url: viewModel.movieImageURL)
                    .frame(height: metrics.size.height * 0.35)
                
                DetailView(viewModel: viewModel)
            }
        }
    }
}

// MARK: - Detail View
struct DetailView: View {
    
    @ObservedObject var viewModel: MovieDetailViewModel
    
    var body: some View {
        ZStack {
            Color(.white)
                .cornerRadius(20)
                .accessibilityIdentifier(AccessibilityIdentifiers.movieDetailContainerView.rawValue)
            
            VStack(alignment: .center) {
                
                DescriptionView(title: viewModel.movieTitle,
                                rating: viewModel.movieRating,
                                description: viewModel.movieDescription)
                
                Spacer()
                
                Button {
                    viewModel.isFavorite = !viewModel.isFavorite
                } label: {
                    if viewModel.isFavoriteMovie {
                        Label("Remove from Favorites", systemImage: "heart.fill")
                    } else {
                        Label("Add to Favorites", systemImage: "heart")
                    }
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .tint(.blue)
                .accessibilityIdentifier(AccessibilityIdentifiers.movieDetailFavoriteButton.rawValue)
                
                Spacer()
            }
            .padding(.leading)
            .offset(y: 25)
        }
    }
}

// MARK: - Description View
struct DescriptionView: View {
    
    var title: String
    var rating: String
    var description: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 20) {
                Text(title)
                    .font(.title)
                    .accessibilityIdentifier(AccessibilityIdentifiers.movieDetailTitleLabel.rawValue)
                
                Text(rating)
                    .font(.callout)
                    .accessibilityIdentifier(AccessibilityIdentifiers.movieDetailRatingLabel.rawValue)
                
                Text(description)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .accessibilityIdentifier(AccessibilityIdentifiers.movieDetailDescLabel.rawValue)
            }
            
            Spacer()
        }
    }
}

// MARK: - Image View
struct ImageView: View {
    
    var url: URL?
    
    var body: some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .scaledToFill()
                .background(.red)
                .ignoresSafeArea()
                .accessibilityIdentifier(AccessibilityIdentifiers.movieDetailBackgroundImageView.rawValue)
        } placeholder: {
            Image(systemName: "film")
        }
    }
}
