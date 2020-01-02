//
//  DataService.swift
//  MVVMAgain
//
//  Created by Vuong on 6/14/19.
//  Copyright © 2019 Vuong. All rights reserved.
//

import UIKit
import AlamofireObjectMapper
import Alamofire

typealias DownloadComplete = (DataResponse<[User]>) -> ()
let usersURL = "https://api.github.com/users"

class DataService {
    
    // Mark: - Singleton
    static let shared = DataService()
    
    // Mark: - Property
    var isNetworkReachable: Bool {
        let manager = NetworkReachabilityManager(host: "www.apple.com")
        return manager?.isReachable ?? false
    }

    // Mark - Services
    func requestFetchUsers(complete: @escaping DownloadComplete) {
        Alamofire.request(usersURL).responseArray { (response: DataResponse<[User]>) in
            complete(response)
        }
    }
    
}
