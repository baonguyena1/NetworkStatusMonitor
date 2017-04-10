//
//  ReachabilityManager.swift
//  NetworkStatusMonitor
//
//  Created by Bao Nguyen on 4/10/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import Foundation
import ReachabilitySwift

protocol NetworkStatusListener: NSObjectProtocol {
    func networkStatusDidChange(_ status: Reachability.NetworkStatus)
}

class ReachabilityManager {
    static let shared = ReachabilityManager()
    
    var isNetworkAvailable : Bool {
        return reachability.currentReachabilityStatus != .notReachable
    }
    
    private let reachability = Reachability()!
    
    // Array of delegates which are interested to listen to network status change
    private var listeners = [NetworkStatusListener]()
    
    @objc private func reachabilityChanged(_ notification: Notification) {
        let reachabiility = notification.object as! Reachability
        
        switch reachabiility.currentReachabilityStatus {
        case .notReachable:
            debugPrint("Network became unreachable")
        case .reachableViaWiFi:
            debugPrint("Network reachable through WiFi")
        case .reachableViaWWAN:
            debugPrint("Network reachable through Cellular Data")
        }
        
        for listener in listeners {
            listener.networkStatusDidChange(reachabiility.currentReachabilityStatus)
        }
    }
    
    func addListener(_ listener: NetworkStatusListener) {
        listeners.append(listener)
    }
    
    func removeListener(_ listener: NetworkStatusListener) {
        listeners = listeners.filter { $0 !== listener }
    }
    
    func startMonitoring() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reachabilityChanged(_:)),
                                               name: ReachabilityChangedNotification,
                                               object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            debugPrint("Could not start reachability notifier")
        }
    }
    
    func stopMonitoring() {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self,
                                                  name: ReachabilityChangedNotification,
                                                  object: reachability)
    }
}
