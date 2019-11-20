//
//  ViewController.swift
//  Jeel_Patel_BarrieTransport
//
//  Created by Jeel Patel on 2019-11-20.
//  Copyright © 2019 Jeel Patel. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK:- Class Variables
    let model = JP_BTS_Model()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let barrieLatitude = 44.3894
        let barrieLongitude = -79.6903
        
        //Center of default map
        let barrieLocation = CLLocationCoordinate2D(latitude: barrieLatitude, longitude: barrieLongitude)
        
        //Create span redius of default area
        let delta = 0.1
        let span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        
        let region = MKCoordinateRegion(center: barrieLocation, span: span)
        
        //Set region
        mapView.setRegion(region, animated: true)
        
        for driver in model.drivers{
            print("Driver name is \(driver.key)")
            //To set random driver location delta must go from to -0.05 to +0.05 degree
            let randLat = Double.random(in: -0.05...0.05)
            let randLong = Double.random(in: -0.05...0.05)
            
            let annotation = MKPointAnnotation()
            
            let pinLocation = CLLocationCoordinate2D(latitude: barrieLatitude + randLat, longitude: barrieLongitude + randLong)
            annotation.coordinate = pinLocation
            annotation.title = driver.key
            annotation.subtitle = driver.value
            
            mapView.addAnnotation(annotation)
        }
        
        
        //Register annotation callout with custom class
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }

}

//Generating custom anootations
class CustomAnnotationView: MKMarkerAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        //Callout implementation
        self.canShowCallout = true
        
        //Callout view uses button
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        button.setTitle("Call", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(CustomAnnotationView.callTheNumber), for: .touchUpInside)
        
        self.rightCalloutAccessoryView = button
    }
    
    //Add IBAction tel link to call button
    @objc func callTheNumber(sender: UIButton){
        let phoneNumber = (annotation?.subtitle)!
        let urlString = "tel://)" + phoneNumber!
        
        if let url = URL(string: urlString){
            //Call now when clicked 
            UIApplication.shared.open(url)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(Coder:) has not been implemented")
    }
}
