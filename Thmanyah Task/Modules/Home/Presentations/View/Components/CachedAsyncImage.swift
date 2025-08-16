//
//  CachedAsyncImage.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 15/08/2025.
//

import SwiftUI

// MARK: - Cached Async Image

struct CachedAsyncImage: View {
    
    // MARK: - Properties
    
    let url: String?
    let placeholder: AnyView
    let contentMode: ContentMode
    
    @StateObject private var loader = AsyncImageLoader()
    
    // MARK: - Initialization
    
    init(
        url: String?,
        contentMode: ContentMode = .fit,
        @ViewBuilder placeholder: () -> some View = {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
        }
    ) {
        self.url = url
        self.contentMode = contentMode
        self.placeholder = AnyView(placeholder())
    }
    
    // MARK: - Body
    
    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else if loader.isLoading {
                placeholder
            } else if loader.error != nil {
                errorView
            } else {
                placeholder
            }
        }
        .onAppear {
            loader.loadImage(from: url)
        }
        .onDisappear {
            loader.cancelLoading()
        }
        .onChange(of: url) { newURL in
            loader.loadImage(from: newURL)
        }
    }
    
    // MARK: - Private Views
    
    private var errorView: some View {
        VStack(spacing: 8) {
            Image(systemName: "photo")
                .foregroundColor(.gray)
                .font(.title2)
            
            Text("Failed to load")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Convenience Initializers

extension CachedAsyncImage {
    
    /// Creates a cached async image with a custom placeholder
    static func withPlaceholder<Placeholder: View>(
        url: String?,
        contentMode: ContentMode = .fit,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) -> CachedAsyncImage {
        CachedAsyncImage(
            url: url,
            contentMode: contentMode,
            placeholder: { AnyView(placeholder()) }
        )
    }
    
    /// Creates a cached async image with a simple loading indicator
    static func withLoading(
        url: String?,
        contentMode: ContentMode = .fit
    ) -> CachedAsyncImage {
        CachedAsyncImage(
            url: url,
            contentMode: contentMode,
            placeholder: {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                    .scaleEffect(0.8)
            }
        )
    }
    
    /// Creates a cached async image with a rectangular placeholder
    static func withRectangularPlaceholder(
        url: String?,
        contentMode: ContentMode = .fit,
        backgroundColor: Color = Color(.systemGray6)
    ) -> CachedAsyncImage {
        CachedAsyncImage(
            url: url,
            contentMode: contentMode,
            placeholder: {
                Rectangle()
                    .fill(backgroundColor)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                            .font(.title2)
                    )
            }
        )
    }
}

// MARK: - Preview

struct CachedAsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            // Loading state
            CachedAsyncImage.withLoading(url: nil)
                .frame(width: 100, height: 100)
                .background(Color.gray.opacity(0.1))
            
            // With rectangular placeholder
            CachedAsyncImage.withRectangularPlaceholder(
                url: "https://example.com/image.jpg",
                backgroundColor: .blue.opacity(0.1)
            )
            .frame(width: 150, height: 100)
            
            // With custom placeholder
            CachedAsyncImage.withPlaceholder(url: nil) {
                Text("No Image")
                    .foregroundColor(.secondary)
            }
            .frame(width: 100, height: 100)
            .background(Color.gray.opacity(0.1))
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}