//
//  AppConfiguration.swift
//  Thmanyah Task
//
//  Created by Khaled Elshamy on 14/08/2025.
//

import Foundation

final class AppConfiguration {
    
    lazy var homeBaseURL: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "HOME_BASE_URL") as? String else {
            fatalError("HomeBaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()
    
    lazy var searchBaseURL: String = {
        guard let imageBaseURL = Bundle.main.object(forInfoDictionaryKey: "SEARCH_BASE_URL") as? String else {
            fatalError("SearchBaseURL must not be empty in plist")
        }
        return imageBaseURL
    }()
}
