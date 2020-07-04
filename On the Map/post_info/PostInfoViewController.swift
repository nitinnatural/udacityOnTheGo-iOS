//
//  PostInfoViewController.swift
//  On the Map
//
//  Created by Nitin Anand on 04/07/20.
//  Copyright © 2020 NI3X. All rights reserved.
//

import UIKit

class PostInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "CANCEL", style: .plain, target: self, action: #selector(handleCancel))
    }
    
    @objc func handleCancel(){
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
