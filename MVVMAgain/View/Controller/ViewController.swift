//
//  ViewController.swift
//  MVVMAgain
//
//  Created by Vuong on 6/14/19.
//  Copyright © 2019 Vuong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Mark: - Properties
    @IBOutlet weak var usersTableView: UITableView!
    
    var userViewModel: UserViewModel!
    private let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userViewModel = UserViewModel(dataService: DataService())
        self.setupUI()
        self.attemptFetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // Mark: - Other func
    func setupUI() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        view.addSubview(activityIndicator)
        usersTableView.delegate = self
        usersTableView.dataSource = self
        self.addrefeshControl()
    }
    
    func attemptFetchUsers() {
        userViewModel.fetchUsers {}
        userViewModel.didFinishFetch = {
            self.usersTableView.reloadData()
        }
        
        userViewModel.showAlertClosure = {
            print("------->>> ERROR:\(self.userViewModel.error.debugDescription)")
        }
    }
    
    @objc func fetchUsers () {
        self.attemptFetchUsers()
    }
    
    func addrefeshControl() {
        usersTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(fetchUsers), for: .valueChanged)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userViewModel.numberOfUsers()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell") as! UserTableViewCell
        userCell.configureUserCell(item: userViewModel.generateUserCellViewModelAtIndex(indexPath.row))
        return userCell
    }
}

extension ViewController: UITableViewDelegate {
}
