//
//  MapViewController.swift
//  On the Map
//
//  Created by Nitin Anand on 04/07/20.
//  Copyright © 2020 NI3X. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    
    @IBOutlet weak var mapView:MKMapView!
    var activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    
    var locations = [UdacityUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        navigationItem.title = "On the Map"
        let refreshButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh,
                        target: self, action: #selector(handleRefreshClick))
        
        let addLocationButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add,
                        target: self, action: #selector(handleAddClick))
        
        navigationItem.setRightBarButtonItems([refreshButton, addLocationButton], animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UdacityApi.getUsers(completionHandler: fetchUsers(response:error:))
    }
    
    func showProgress() {
        // todo need to correct here
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
    
    
    
    @objc func handleAddClick(){
        performSegue(withIdentifier: "NavToPostInfoFromMapView", sender: self)
//        let storyboard = UIStoryboard (name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "PostInfoViewController")as! PostInfoViewController
//        present(vc, animated: true, completion: nil)
    }
    
    @objc func handleRefreshClick(){
        showProgress()
        UdacityApi.getUsers(completionHandler: fetchUsers(response:error:))
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
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                do {
                    app.openURL(URL(string: toOpen)!)
                } catch {
                    showAlert(message: error.localizedDescription)
                }
            }
        }
    }
    //    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    //
    //        if control == annotationView.rightCalloutAccessoryView {
    //            let app = UIApplication.sharedApplication()
    //            app.openURL(NSURL(string: annotationView.annotation.subtitle))
    //        }
    //    }
    
    
    
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
                self.mapView.addAnnotations(self.makeMapPointAnnotations(locations: self.locations))
            }
        }
    }
    
    
    func makeMapPointAnnotations(locations:[UdacityUser]) -> [MKPointAnnotation] {
        var annotations = [MKPointAnnotation]()
        for location in locations {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(location.latitude)
            let long = CLLocationDegrees(location.longitude)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = location.firstName
            let last = location.lastName
            let mediaURL = location.mediaURL
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            annotations.append(annotation)
        }
        return annotations
    }
    
    

}
