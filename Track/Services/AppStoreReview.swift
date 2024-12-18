//
//  AppStoreReview.swift
//  Track
//
//  Created by Ethan Maxey on 12/13/24.
//

import UIKit

enum AppStoreReview {
    static func requestReviewManually() {
        let url = "https://apps.apple.com/app/id6670730073?action=write-review"
        guard let writeReviewURL = URL(string: url) else {
            return
        }
        UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
    }
}
