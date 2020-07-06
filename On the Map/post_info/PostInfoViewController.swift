//
//  PostInfoViewController.swift
//  On the Map
//
//  Created by Nitin Anand on 04/07/20.
//  Copyright © 2020 NI3X. All rights reserved.
//

import UIKit
import MapKit

class PostInfoViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var ivIcon: UIImageView!
    @IBOutlet weak var svTextFieldBtn: UIStackView!
    @IBOutlet weak var finishBtn: UIButton!
    
    @IBOutlet weak var linkField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    
    var activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    var postLocationRequest:PostUserLocationRequest!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "CANCEL", style: .plain, target: self, action: #selector(handleCancel))
        
        mapView.isHidden = true
        finishBtn.isHidden = true
        mapView.delegate = self
    }
    
    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
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
    

    func forwardGeoCoder(address:String, link:String){
        showProgress()
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            
            self.hideActivity()
            
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    // handle no location found
                    self.showAlert(message: "no location found")
                    return
                }
            
            self.switchToMapView(true)
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(location.coordinate.latitude)
            let long = CLLocationDegrees(location.coordinate.longitude)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            
            let firstName = "Dr. Sheldon"
            let lastName = "Cooper"
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(firstName) \(lastName)"
            annotation.subtitle = link
            
            // make request
            let key:String = (UIApplication.shared.delegate as! AppDelegate).userKey
            self.postLocationRequest = PostUserLocationRequest(uniqueKey: key,
                                    firstName: firstName,
                                    lastName: lastName,
                                    mapString: address,
                                    mediaURL: link,
                                    latitude: lat,
                                    longitude: long
                                    
            )
            
            
            self.mapView.addAnnotation(annotation)
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
            self.mapView.setRegion(region, animated: true)
        
        }
    }
 
    @IBAction func handleFinishClick(_ sender: Any) {
        showProgress()
        UdacityApi.postUserLocation(userLocationRequest: postLocationRequest, completionHandler: pushUserLocation(data:error:))
    }
    
    
    func pushUserLocation(data:String?, error:Error?) {
        DispatchQueue.main.async {
            self.hideActivity()
            if error == nil {
                print("posted")
                self.dismiss(animated: true, completion: nil)
            } else {
                self.showAlert(message: "Something went wrong. Please try again!")
            }
        }
        
    }
    
    @IBAction func handleFindLocationClick(_ sender: Any) {
        let location = locationField.text ?? ""
        let mediaUrl = linkField.text ?? ""
        
        if (location.isEmpty) {
            showToast("location is required")
            return
        }
        
        if (mediaUrl.isEmpty) {
            showToast("url is required")
            return
        }
        
        if Reachability.isConnectedToNetwork() {
            forwardGeoCoder(address: location, link: mediaUrl)
        } else {
            showToast("no network")
        }
    
    }
    
    func switchToMapView(_ enable:Bool) {
        if enable {
            svTextFieldBtn.isHidden = true
            mapView.isHidden = false
            ivIcon.isHidden = true
            finishBtn.isHidden = false
        } else {
            svTextFieldBtn.isHidden = false
            mapView.isHidden = true
            ivIcon.isHidden = false
            finishBtn.isHidden = true
        }
    }
    
    func showToast(_ message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
}
