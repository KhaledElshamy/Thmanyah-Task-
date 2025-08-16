//
//  AsyncImageLoader.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 15/08/2025.
//

import Foundation
import UIKit
import Combine

// MARK: - Async Image Loader

@MainActor
final class AsyncImageLoader: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var image: UIImage?
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    // MARK: - Dependencies
    
    private let cacheService: ImageCacheServiceProtocol
    private let downloader: ImageDownloaderProtocol
    private var currentTask: Task<Void, Never>?
    
    // MARK: - Initialization
    
    init(
        cacheService: ImageCacheServiceProtocol = ImageCacheService.shared,
        downloader: ImageDownloaderProtocol = ImageDownloader()
    ) {
        self.cacheService = cacheService
        self.downloader = downloader
    }
    
    // MARK: - Public Methods
    
    func loadImage(from url: String?) {
        // Cancel any existing task
        currentTask?.cancel()
        
        // Reset state
        error = nil
        
        guard let url = url, !url.isEmpty else {
            image = nil
            isLoading = false
            return
        }
        
        // Check cache first
        if let cachedImage = cacheService.cachedImage(for: url) {
            image = cachedImage
            isLoading = false
            return
        }
        
        // Download image
        isLoading = true
        currentTask = Task { [weak self] in
            await self?.downloadAndCacheImage(from: url)
        }
    }
    
    func cancelLoading() {
        currentTask?.cancel()
        currentTask = nil
        isLoading = false
    }
    
    // MARK: - Private Methods
    
    private func downloadAndCacheImage(from url: String) async {
        do {
            let downloadedImage = try await downloader.downloadImage(from: url)
            
            // Check if task was cancelled
            guard !Task.isCancelled else { return }
            
            // Cache the image
            cacheService.cacheImage(downloadedImage, for: url)
            
            // Update UI on main thread
            await MainActor.run {
                self.image = downloadedImage
                self.isLoading = false
            }
            
        } catch {
            // Check if task was cancelled
            guard !Task.isCancelled else { return }
            
            // Update UI on main thread
            await MainActor.run {
                self.error = error
                self.isLoading = false
            }
        }
    }
    
    deinit {
        currentTask?.cancel()
    }
}