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
}

enum SortOption: String, CaseIterable, Codable {
    case dateAdded = "Date Added"
    case alphabetical = "Alphabetical"
}

enum DateFilterOperator: String, CaseIterable, Codable {
    case lessThan = "Is Less Than"
    case greaterThan = "Is Greater Than"
    case equal = "Equals"
    case any = "No Filter"
}
