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
    
    var locations = [UdacityUser]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locations = (UIApplication.shared.delegate as! AppDelegate).locations
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
