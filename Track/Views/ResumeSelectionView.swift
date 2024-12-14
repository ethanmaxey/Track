//
//  ResumeSelectionView.swift
//  Track
//
//  Created by Ethan Maxey on 12/10/24.
//

import SwiftUI

struct ResumeSelectionView: View {
    @EnvironmentObject var viewModel: ViewModel
    @ObservedObject var job: JobListing
    
    var body: some View {
        List {
            ForEach(viewModel.resumes) { resume in
                if let fileName = resume.fileName {
                    Button(action: {
                        job.resume = resume
                        viewModel.saveContext()
                    }) {
                        HStack {
                            Text(fileName)
                            if job.resume == resume {
                                Spacer()
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Select Resume")
    }
}
