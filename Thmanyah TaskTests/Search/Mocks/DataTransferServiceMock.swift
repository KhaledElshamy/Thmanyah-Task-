//
//  DataTransferServiceMock.swift
//  Thmanyah TaskTests
//
//  Created by Khaled Elshamy on 17/08/2025.
//

import XCTest
@testable import Thmanyah_Task

class DataTransferServiceMock: DataTransferService {
    
    // MARK: - Mock Properties
    var result: Result<Any, Error>!
    var requestCallsCount = 0
    var requestCalledWithEndpoints: [String] = []
    
    // MARK: - Mock Implementation
    func request<T: Decodable, E: ResponseRequestable>(
        with endpoint: E
    ) async throws -> T where E.Response == T {
        requestCallsCount += 1
        requestCalledWithEndpoints.append(endpoint.path)
        
        if let result = result {
            switch result {
            case .success(let response):
                guard let typedResponse = response as? T else {
                    throw DataTransferMockError.typeMismatch
                }
                return typedResponse
            case .failure(let error):
                throw error
            }
        }
        
        throw DataTransferMockError.requestFailed
    }
    
    func request<E: ResponseRequestable>(
        with endpoint: E
    ) async throws where E.Response == Void {
        requestCallsCount += 1
        requestCalledWithEndpoints.append(endpoint.path)
        
        if let result = result {
            switch result {
            case .success(_):
                return
            case .failure(let error):
                throw error
            }
        }
        
        throw DataTransferMockError.requestFailed
    }
}

// MARK: - DataTransfer Mock Errors
enum DataTransferMockError: Error, Equatable {
    case requestFailed
    case networkError
    case decodingError
    case typeMismatch
    case invalidEndpoint
    
    var localizedDescription: String {
        switch self {
        case .requestFailed:
            return "Mock request failed"
        case .networkError:
            return "Mock network error"
        case .decodingError:
            return "Mock decoding error"
        case .typeMismatch:
            return "Mock type mismatch"
        case .invalidEndpoint:
            return "Mock invalid endpoint"
        }
    }
}
