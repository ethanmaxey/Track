//
//  L10n.swift
//  Track
//
//  Created by Ethan Maxey on 2/27/25.
//


import SwiftUI

public struct L10n {
    static func getTranslation(for key: String) -> String  {
        NSLocalizedString(key, comment: String())
    }
    
    static let about = getTranslation(for: "About")
    static let accepted = getTranslation(for: "Accepted")
    static let appVersion = getTranslation(for: "App Version")
    static let applyFilters = getTranslation(for: "Apply Filters")
    static let ascending = getTranslation(for: "Ascending")
    static let autoAddEmojiToJobs = getTranslation(for: "Auto-Add Emoji to Jobs")
    static let cancel = getTranslation(for: "Cancel")
    static let checkOutMyProgress = getTranslation(for: "Check out my job search progress!")
    static let clearFilters = getTranslation(for: "Clear Filters")
    static let close = getTranslation(for: "Close")
    static let company = getTranslation(for: "Company")
    static let congrats = getTranslation(for: "Congrats! Where did you apply?")
    static let contactSupport = getTranslation(for: "Contact Support")
    static let criteria = getTranslation(for: "Criteria")
    static let date = getTranslation(for: "Date")
    static let declined = getTranslation(for: "Declined")
    static let descending = getTranslation(for: "Descending")
    static let details = getTranslation(for: "Details")
    static let enterJobNameHere = getTranslation(for: "Enter job name here.")
    static let feedback = getTranslation(for: "Feedback")
    static let filterByDate = getTranslation(for: "Filter by Date")
    static let filterByStatus = getTranslation(for: "Filter by Status")
    static let filters = getTranslation(for: "Filters")
    static let ghosted = getTranslation(for: "Ghosted")
    static let interview = getTranslation(for: "Interview")
    static let jobDescription = getTranslation(for: "Job Description")
    static let jobTitle = getTranslation(for: "Job Title")
    static let jobs = getTranslation(for: "Jobs")
    static let leaveAReview = getTranslation(for: "Leave a Review")
    static let noOffer = getTranslation(for: "No Offer")
    static let offer = getTranslation(for: "Offer")
    static let order = getTranslation(for: "Order")
    static let phaseI = getTranslation(for: "Phase I")
    static let phaseII = getTranslation(for: "Phase II")
    static let phaseIII = getTranslation(for: "Phase III")
    static let preferences = getTranslation(for: "Preferences")
    static let privacyPolicy = getTranslation(for: "Privacy Policy")
    static let rejected = getTranslation(for: "Rejected")
    static let salaryRejected = getTranslation(for: "Salary Rejected")
    static let salaryRange = getTranslation(for: "Salary Range")
    static let selectAJobFromTheSidebarToViewDetails = getTranslation(for: "Select a job from the sidebar to view details.")
    static let selectResume = getTranslation(for: "Select Resume")
    static let settings = getTranslation(for: "Settings")
    static let sortBy = getTranslation(for: "Sort By")
    static let sortOptions = getTranslation(for: "Sort Options")
    static let support = getTranslation(for: "Support")
    static let title = getTranslation(for: "Title")
    static let track = getTranslation(for: "Track")
    static let visualize = getTranslation(for: "Visualize")
    static let yesDone = getTranslation(for: "Yes, Done")
    
    // Need to add
    static let applications = getTranslation(for: "Applications")
    static let interviews = getTranslation(for: "Interviews")
    static let offers = getTranslation(for: "Offers")
    static let noAnswer = getTranslation(for: "No Answer")
    static let interviewed = getTranslation(for: "Interviewed")
    static let oa = getTranslation(for: "Online Assesment")
    static let dateAdded = getTranslation(for: "Date Added")
    static let alphabetical = getTranslation(for: "Alphabetical")
    static let lessThan = getTranslation(for: "Is Less Than")
    static let greaterThan = getTranslation(for: "Is Greater Than")
    static let equals = getTranslation(for: "Equals")
    static let noFilter = getTranslation(for: "No Filter")
}
