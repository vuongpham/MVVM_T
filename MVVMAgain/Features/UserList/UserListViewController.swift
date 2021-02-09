//
//  ViewController.swift
//  MVVMAgain
//
//  Created by Vuong on 6/14/19.
//  Copyright © 2019 Vuong. All rights reserved.
//

import UIKit
import RxSwift

class UserListViewController: UIViewController {

    @IBOutlet weak var usersTableView: UITableView!

    // MARK: - Properties
    fileprivate var userViewModel: UserViewModel!
    fileprivate let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    fileprivate let refreshControl = UIRefreshControl()
    fileprivate let disposeBag = DisposeBag()

//    init(viewModel: UserViewModel) {
//        self.userViewModel = viewModel
//        super.init(nibName: "UserListViewController", bundle: Bundle(for: type(of: self)))
//
////        //Storyboard
////        var viewControllerStoryboardId = "ViewController"
////        var storyboardName = "Main"
////        var storyboard = UIStoryboard(name: storyboardName, bundle: NSBundle.mainBundle())
////        let viewController = storyboard.instantiateViewControllerWithIdentifier(viewControllerStoryboardId) as UIViewController!
//    }
//    required init?(coder: NSCoder) {
//        return nil
//    }
}

// MARK: - Life cycle
extension UserListViewController {

    override func loadView() {
        super.loadView()
        self.setupViews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "User List"

        userViewModel = UserViewModel(dataService: DataService())
        attemptFetchUsers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: - Setups
extension UserListViewController {
    func setupViews() {
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

extension UserListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userViewModel.numberOfUsers()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell") as! UserTableViewCell
        userCell.configureUserCell(item: userViewModel.generateUserCellViewModelAtIndex(indexPath.row))
        return userCell
    }
}

extension UserListViewController: UITableViewDelegate {}
