//
//  MVVMAgainTests.swift
//  MVVMAgainTests
//
//  Created by Vuong on 6/14/19.
//  Copyright © 2019 Vuong. All rights reserved.
//

import XCTest
import AlamofireObjectMapper
import Alamofire

@testable import MVVMAgain

class MVVMAgainTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoadAllUser() {
        var numberUserFromAPI = -1
        
        let viewModel = UserViewModel(dataService: DataService())
        viewModel.fetchUsers {}
        
        Alamofire.request(usersURL).responseArray { (response: DataResponse<[User]>) in
            numberUserFromAPI = response.result.value?.count ?? -1
        }
        
        // I think delay is not good :D
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            XCTAssertEqual(viewModel.numberOfUsers(), numberUserFromAPI)
        }
    }
}
