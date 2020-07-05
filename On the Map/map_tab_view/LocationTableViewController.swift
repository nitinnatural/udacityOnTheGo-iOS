//
//  LocationTableViewController.swift
//  On the Map
//
//  Created by Nitin Anand on 04/07/20.
//  Copyright © 2020 NI3X. All rights reserved.
//

import UIKit
import SafariServices

class LocationTableViewController: UITableViewController {
    
    var locations = [StudentInformation]()
    var activityIndicator = UIActivityIndicatorView(style: .whiteLarge)

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "On the Map"
        let refreshButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh,
                                            target: self, action: #selector(handleRefreshClick))
        
        let addLocationButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add,
                                                target: self, action: #selector(handleAddClick))
        
        navigationItem.setRightBarButtonItems([refreshButton, addLocationButton], animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locations = (UIApplication.shared.delegate as! AppDelegate).locations
        tableView.reloadData()
    }
    
    @objc func handleAddClick(){
        performSegue(withIdentifier: "NavToPostInfoFromTableView", sender: self)
    }
    @objc func handleRefreshClick(){
        showProgress()
        UdacityApi.getUsers(completionHandler: fetchUsers(response:error:))
    }
    
    
    func showProgress() {
        activityIndicator.center = self.view.center
        activityIndicator.color = UIColor.darkGray
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func hideActivity(){
        activityIndicator.stopAnimating()
    }
    
    func showAlert(message:String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func fetchUsers(response:UserResponse?, error:Error?) {
        DispatchQueue.main.async {
            self.hideActivity()
            if let error = error {
                self.showAlert(message: error.localizedDescription)
                return
            }
            
            if response != nil {
                (UIApplication.shared.delegate as! AppDelegate).locations = (response?.results)!
                self.locations = (response?.results)!
            }
        }
    }
    
    

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return locations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "location_table_cell", for: indexPath) as! LocationTableViewCell
        let location = locations[indexPath.row]
        cell.labelLink.text = location.mediaURL
        cell.labelName.text = location.firstName + " " + location.lastName
        return cell
    }



    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openUrl(locations[indexPath.row].mediaURL)
    }
    
    func openUrl(_ url:String){
        guard let url = URL(string: url) else { return }
        let svc = SFSafariViewController(url: url)
        present(svc, animated: true, completion: nil)
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
