//
//  UserViewModel.swift
//  MVVMAgain
//
//  Created by Vuong on 6/14/19.
//  Copyright © 2019 Vuong. All rights reserved.
//

import Foundation
import RealmSwift

struct UserCellViewModel {
    let id: Int?
    let userName: String?
    let avatarURL: String?
    init(id: Int? = nil, userName: String? = nil, avatarURL: String? = nil) {
        self.id = id
        self.userName = userName
        self.avatarURL = avatarURL
    }
}

protocol UserViewModelProtocol {
    var userList: Results<User>? {set get}
    func numberOfUsers () -> Int
    func generateUserCellViewModelAtIndex(_ index: Int) -> UserCellViewModel?
}

class UserViewModel: UserViewModelProtocol {
    
    // Mark: - Properties
    private var dataService: DataService?
    let realm = try! Realm()
    
    var error: Error? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var userList: Results<User>? {
        didSet {
            self.didFinishFetch?()
        }
    }
    
    // Mark: - Closures for callback
    var showAlertClosure: (() -> ())?
    var didFinishFetch: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    
    // Mark: - Constructor
    init(dataService: DataService) {
        self.dataService = dataService
    }
    
    // Mark: - Network call
    func fetchUsers(compelete: () -> ()) {
        guard let isNetworkReachable = self.dataService?.isNetworkReachable else {
            return
        }
        
        if isNetworkReachable {
            // Get data from API
            self.dataService?.requestFetchUsers(complete: { (responseServer) in
                self.error = responseServer.error
                if let users = responseServer.result.value {
                    do {
                        try self.realm.write {
                            for user in users {
                                self.realm.add(user, update: true)
                            }
                        }
                        // Retrieve data offline from Reaml.
                        self.userList  = { self.realm.objects(User.self) }()
                    } catch {}
                }
            })
        } else {
            // Retrieve data offline from Reaml
            userList  = { self.realm.objects(User.self) }()
        }
    }
    
    // Mark: - Implement protocol funcs
    func generateUserCellViewModelAtIndex(_ index: Int) -> UserCellViewModel? {
        guard let user = self.userList?[index] else {
            return nil
        }
        return UserCellViewModel(id: user.id, userName: user.userName, avatarURL: user.avatarURL)
    }
    
    func numberOfUsers () -> Int {
        return userList?.count ?? 0
    }
}
