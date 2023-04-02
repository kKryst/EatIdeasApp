//
//  NetworkManager.swift
//  EatIdeasApp
//
//  Created by Krystian Konieczko on 02/04/2023.
//

import Foundation
import Alamofire


#warning("TODO: read documentation to check if theres a delegate protocool to call out when internet connection is back")
class NetworkManager {
    
    
    let networkManager = NetworkReachabilityManager()
    
    func isConnectedToInternet() -> Bool {
        if networkManager?.isReachable ?? false {
            // The device has an internet connection.
            return true
        } else {
            // The device doesn't have an internet connection.
            return false
        }
    }

}



