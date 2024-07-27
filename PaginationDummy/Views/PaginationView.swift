//
//  HitsView.swift
//  PaginationDummy
//
//  Created by Neeshu Kumar on 26/07/24.
//

import SwiftUI

struct PaginationView: View {
    @StateObject private var viewModel = PaginationViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.images) { hit in
                VStack(alignment: .center) {
                    if let url = URL(string: hit.previewURL) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 300, height: 300) // Adjust these values as needed
                                .clipped()
                        } placeholder: {
                            ProgressView()
                                .frame(width: 300, height: 300) // Adjust these values as needed
                        }
                        .frame(width: 300, height: 300) // Adjust these values as needed
                    }
                    
                    HStack {
                        Image(systemName: "heart")
                        Text("\(hit.likes)")
                        Spacer()
                        Image(systemName: "message")
                        Text("\(hit.comments)")
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
                .onAppear {
                    if hit == viewModel.images.last {
                        viewModel.fetchHits()
                    }
                }
                
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .navigationTitle("Pagination")
            .alert(isPresented: Binding<Bool>(
                get: { viewModel.errorMessage != nil },
                set: { _ in viewModel.errorMessage = nil }
            )) {
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
            }
        }
    }
}
