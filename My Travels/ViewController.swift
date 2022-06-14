//
//  ViewController.swift
//  My Travels
//
//  Created by Guilherme Costa on 13/06/22.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configManagerLocation()
        
        let recognitionGesture = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.mark(gesture:)))
        recognitionGesture.minimumPressDuration = 2
        
        map.addGestureRecognizer(recognitionGesture)
    }
    
    @objc func mark(gesture: UIGestureRecognizer) {
        if gesture.state == UIGestureRecognizer.State.began {
            let point = gesture.location(in: self.map)
            let coord = map.convert(point, toCoordinateFrom: self.map)
            let location = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
            
            var placeFull = ""
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (place, err) in
                if err == nil {
                    if let placeData = place?.first {
                        if let name = placeData.name {
                            placeFull = name
                        } else {
                            if let address = placeData.thoroughfare {
                                placeFull = address
                            }
                        }
                    }
                    
                    print(placeFull)
                    let annotation = MKPointAnnotation()
                    annotation.coordinate.latitude = coord.latitude
                    annotation.coordinate.longitude = coord.longitude
                    annotation.title = placeFull
                    annotation.subtitle = placeFull
                    
                    self.map.addAnnotation(annotation)
                }
            })
        }
    }

    func configManagerLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

}

