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
    var travel: Dictionary<String, String> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if travel == [:] {
            configManagerLocation()
            
            let recognitionGesture = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.mark(gesture:)))
            recognitionGesture.minimumPressDuration = 2
            
            map.addGestureRecognizer(recognitionGesture)
        } else {
            plot()
        }
        
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
                    
                    self.travel = ["place": placeFull, "lat": String(coord.latitude), "lng": String(coord.longitude)]
                    Storage.save(travel: self.travel)
                    
                    self.plot()
                }
            })
        }
    }
    
    func plot() {
        if let latS = travel["lat"] {
            if let lngS = travel["lng"] {
                let annotation = MKPointAnnotation()
                
                annotation.coordinate.latitude = Double(latS)!
                annotation.coordinate.longitude = Double(lngS)!
                annotation.title = travel["place"]
                annotation.subtitle = travel["place"]
                
                self.map.addAnnotation(annotation)
                
                let location = CLLocationCoordinate2DMake(Double(latS)!, Double(lngS)!)
                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                let region: MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
                self.map.setRegion(region, animated: true)
            }
        }
        
    }

    func configManagerLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

}

