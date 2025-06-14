//
//  RoutebirdError.swift
//  Routebird
//
//  Created by İsmail Palalı on 14.06.2025.
//


enum RoutebirdError: Error {
    case decodingFailed
    case encodingFailed
    case geocodeFailed
    case permissionDenied
    
    var localizedDescription: String {
        switch self {
        case .decodingFailed: return "error_decoding_failed".localized
        case .encodingFailed: return "error_encoding_failed".localized
        case .geocodeFailed: return "error_geocode_failed".localized
        case .permissionDenied: return "error_permission_denied".localized
        }
    }
}
