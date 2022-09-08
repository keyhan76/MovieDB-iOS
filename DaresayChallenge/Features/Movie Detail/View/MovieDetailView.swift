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
                
                ImageView()
                    .frame(height: metrics.size.height * 0.35)
                
                DetailView(isFavorite: viewModel.isAvailableInFavorites(), viewModel: viewModel)
            }
        }
    }
}

// MARK: - Detail View
struct DetailView: View {
    
    @State var isFavorite: Bool
    @ObservedObject var viewModel: MovieDetailViewModel
    
    var body: some View {
        ZStack {
            Color(.white)
                .cornerRadius(20)
            
            VStack(alignment: .center) {
                
                DescriptionView(title: viewModel.movieTitle,
                                rating: viewModel.movieRating,
                                description: viewModel.movieDescription)
                
                Spacer()
                
                Button {
                    isFavorite = !isFavorite
                    viewModel.addToFavorites(isFavorite: isFavorite)
                } label: {
                    if isFavorite {
                        Label("Remove from Favorites", systemImage: "heart.fill")
                    } else {
                        Label("Add to Favorites", systemImage: "heart")
                    }
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .tint(.blue)
                
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
                
                Text(rating)
                    .font(.callout)
                
                Text(description)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
    }
}

// MARK: - Image View
struct ImageView: View {
    var body: some View {
        Image("")
            .resizable()
            .scaledToFill()
            .background(.red)
            .ignoresSafeArea()
    }
}
