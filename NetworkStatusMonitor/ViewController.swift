//
//  ViewController.swift
//  NetworkStatusMonitor
//
//  Created by Bao Nguyen on 4/10/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import UIKit
import ReachabilitySwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ReachabilityManager.shared.addListener(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ReachabilityManager.shared.removeListener(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: NetworkStatusListener {
    func networkStatusDidChange(_ status: Reachability.NetworkStatus) {
        switch status {
        case .notReachable:
            debugPrint("notReachable")
        case .reachableViaWiFi:
            debugPrint("reachableViaWiFi")
        case .reachableViaWWAN:
            debugPrint("reachableViaWWAN")
        }
    }
}

