//
//  Formatter.swift
//  Track
//
//  Created by Ethan Maxey on 9/1/24.
//

import Foundation

struct Formatter {
    static let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
}
