//
//  JobStatus.swift
//  Track
//
//  Created by Ethan Maxey on 1/14/25.
//

import Foundation

struct FilterState: Equatable, Codable {
    var selectedDate: Date?
    var dateFilterOperator: DateFilterOperator? = .any
    var selectedStatuses: [JobStatus] = []
    var sortOption: SortOption = .dateAdded
    var isAscending: Bool = true
}

enum JobStatus: String, Identifiable, CaseIterable, Codable {
    case declined
    case ghosted
    case inteviewed
    case no_offer = "No Offer"
    case oa = "Online Assesment"
    case offer
    case rejected
    
    var id: String { rawValue }
    
    var text: String {
        switch self {
        case .no_offer:
            return L10n.noOffer
        case .declined:
            return L10n.declined
        case .ghosted:
            return L10n.ghosted
        case .inteviewed:
            return L10n.interviewed
        case .offer:
            return L10n.offer
        case .rejected:
            return L10n.rejected
        case .oa:
            return L10n.oa
        }
    }
}

enum SortOption: String, CaseIterable, Codable {
    case dateAdded
    case alphabetical
    
    var text: String {
        switch self {
        case .dateAdded:
            return L10n.dateAdded
        case .alphabetical:
            return L10n.alphabetical
        }
    }
}

enum DateFilterOperator: String, CaseIterable, Codable {
    case lessThan
    case greaterThan
    case equals
    case any
    
    var text: String {
        switch self {
        case .lessThan:
            return L10n.lessThan
        case .greaterThan:
            return L10n.greaterThan
        case .equals:
            return L10n.equals
        case .any:
            return L10n.noFilter
        }
    }
}
