//
//  HomeViewController.swift
//  JRepoScan
//
//  Created by Michelli Cristina de Paulo Lima on 27/05/25.
//

import UIKit

class HomeViewController: UIViewController {

    var homeView: HomeView?

    override func loadView() {
        homeView = HomeView()
        view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

