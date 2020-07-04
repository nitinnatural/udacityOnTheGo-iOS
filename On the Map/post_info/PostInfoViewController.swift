//
//  PostInfoViewController.swift
//  On the Map
//
//  Created by Nitin Anand on 04/07/20.
//  Copyright © 2020 NI3X. All rights reserved.
//

import UIKit
import MapKit

class PostInfoViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var ivIcon: UIImageView!
    @IBOutlet weak var svTextFieldBtn: UIStackView!
    @IBOutlet weak var finishBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "CANCEL", style: .plain, target: self, action: #selector(handleCancel))
        
        mapView.isHidden = true
        finishBtn.isHidden = true
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
    @IBAction func handleFinishClick(_ sender: Any) {
    }
    
    @IBAction func handleFindLocationClick(_ sender: Any) {
        svTextFieldBtn.isHidden = true
        mapView.isHidden = false
        ivIcon.isHidden = true
        finishBtn.isHidden = false
    }
}
