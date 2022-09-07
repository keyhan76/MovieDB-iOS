//
//  MovieDetailView.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-09-07.
//

import SwiftUI

struct MovieDetailView: View {
    var body: some View {
        GeometryReader { metrics in
            VStack(spacing: 0) {
                
                ImageView()
                    .frame(height: metrics.size.height * 0.35)
                
                DetailView()
                
            }
        }
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView()
    }
}

// MARK: - Detail View
struct DetailView: View {
    var body: some View {
        ZStack {
            Color(.white)
                .cornerRadius(20)
            
            VStack(alignment: .center) {
                
                DescriptionView()
                
                Spacer()
                
                Button {
                    
                } label: {
                    Label("Add to Favorites", systemImage: "heart")
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
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Title goes here")
                    .font(.title)
                
                Text("Rating")
                    .font(.callout)
                
                Text("Description")
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
