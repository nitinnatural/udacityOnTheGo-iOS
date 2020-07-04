//
//  MapViewController.swift
//  On the Map
//
//  Created by Nitin Anand on 04/07/20.
//  Copyright © 2020 NI3X. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UdacityApi.getUsers(completionHandler: fetchUsers(response:error:))
    }
    
    
    func fetchUsers(response:UserResponse?, error:Error?) {
        print("from fetch user")
    }

}
