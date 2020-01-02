//
//  User.swift
//  MVVMAgain
//
//  Created by Vuong on 6/14/19.
//  Copyright © 2019 Vuong. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class User: Object, Mappable {
    @objc dynamic  var id: Int = -1
    @objc dynamic  var userName: String = ""
    @objc dynamic  var avatarURL: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        userName <- map["login"]
        avatarURL <- map["avatar_url"]
    }
}

