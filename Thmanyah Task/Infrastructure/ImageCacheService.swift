//
//  ImageCacheService.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 15/08/2025.
//

import Foundation
import UIKit

// MARK: - Protocols

protocol ImageCacheServiceProtocol {
    func cachedImage(for url: String) -> UIImage?
    func cacheImage(_ image: UIImage, for url: String)
    func clearCache()
    func removeCachedImage(for url: String)
}

protocol ImageDownloaderProtocol {
    func downloadImage(from url: String) async throws -> UIImage
}

// MARK: - Image Cache Service

final class ImageCacheService: ImageCacheServiceProtocol {
    
    // MARK: - Properties
    
    private let cache = NSCache<NSString, UIImage>()
    private let cacheQueue = DispatchQueue(label: "com.thmanyah.imagecache", qos: .utility)
    
    // MARK: - Singleton
    
    static let shared = ImageCacheService()
    
    private init() {
        setupCache()
    }
    
    // MARK: - Public Methods
    
    func cachedImage(for url: String) -> UIImage? {
        return cacheQueue.sync {
            return cache.object(forKey: NSString(string: url))
        }
    }
    
    func cacheImage(_ image: UIImage, for url: String) {
        cacheQueue.async { [weak self] in
            self?.cache.setObject(image, forKey: NSString(string: url))
        }
    }
    
    func clearCache() {
        cacheQueue.async { [weak self] in
            self?.cache.removeAllObjects()
        }
    }
    
    func removeCachedImage(for url: String) {
        cacheQueue.async { [weak self] in
            self?.cache.removeObject(forKey: NSString(string: url))
        }
    }
    
    // MARK: - Private Methods
    
    private func setupCache() {
        // Configure cache limits
        cache.countLimit = 100 // Maximum 100 images
        cache.totalCostLimit = 50 * 1024 * 1024 // 50 MB
        
        // Listen for memory warnings
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleMemoryWarning),
            name: UIApplication.didReceiveMemoryWarningNotification,
            object: nil
        )
    }
    
    @objc private func handleMemoryWarning() {
        clearCache()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Image Downloader

final class ImageDownloader: ImageDownloaderProtocol {
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func downloadImage(from url: String) async throws -> UIImage {
        guard let imageURL = URL(string: url) else {
            throw ImageDownloadError.invalidURL
        }
        
        let (data, response) = try await urlSession.data(from: imageURL)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw ImageDownloadError.invalidResponse
        }
        
        guard let image = UIImage(data: data) else {
            throw ImageDownloadError.invalidImageData
        }
        
        return image
    }
}

// MARK: - Errors

enum ImageDownloadError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidImageData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid image URL"
        case .invalidResponse:
            return "Invalid server response"
        case .invalidImageData:
            return "Invalid image data"
        }
    }
}
