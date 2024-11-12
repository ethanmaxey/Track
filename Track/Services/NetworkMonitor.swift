//
//  NetworkMonitor.swift
//  Track
//
//  Created by Ethan Maxey on 11/11/24.
//

import Observation
import Network

@Observable
final class NetworkMonitor {
    var hasNetworkConnection = true
    var isUsingMobileConnection = false // low data usage ( 3G / 4G / etc )
    
    private let networkMonitor = NWPathMonitor()
    
    init() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            self?.hasNetworkConnection = path.status == .satisfied
            self?.isUsingMobileConnection = path.usesInterfaceType(.cellular)
        }
        
        networkMonitor.start(queue: DispatchQueue.global())
    }
}
