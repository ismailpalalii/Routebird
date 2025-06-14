//
//  RoutebirdError.swift
//  Routebird
//
//  Created by İsmail Palalı on 15.06.2025.
//


enum RoutebirdError: Error {
    case decodingFailed
    case encodingFailed
    case geocodeFailed
    case permissionDenied
    case coreDataSaveFailed(Error)
    case coreDataDeletionFailed
    
    var localizedDescription: String {
        switch self {
        case .decodingFailed: return "error_decoding_failed".localized
        case .encodingFailed: return "error_encoding_failed".localized
        case .geocodeFailed: return "error_geocode_failed".localized
        case .permissionDenied: return "error_permission_denied".localized
        case .coreDataSaveFailed(let error): return "Core Data error: \(error.localizedDescription)"
        case .coreDataDeletionFailed: return "error_deletion_failed".localized
        }
    }
}
