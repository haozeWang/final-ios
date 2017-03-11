//
//  ViewController.swift
//  hello map
//
//  Created by Meng Wang on 3/8/17.
//  Copyright © 2017 Meng Wang. All rights reserved.
//

import UIKit
import MapKit


/// - Attribution: https://www.thorntech.com/2016/01/how-to-search-for-location-using-apples-mapkit/
class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    // search controller
    var locationSearchController: UISearchController? = nil
    
    // selected destination location
    var selectedPin: MKPlacemark? = nil
    
    // current location
    var currentLocation: CLLocation? = nil
    
    
    /*
     let regionRadius: CLLocationDistance = 1000
     func centerMapOnLocation(location: CLLocation) {
     let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
     regionRadius * 2.0, regionRadius * 2.0)
     mapView.setRegion(coordinateRegion, animated: true)
     }
     */
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize the location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        
        // initialize the location search table and search controller
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTableViewController") as! LocationSearchTableViewController
        
        locationSearchTable.mapView = mapView
        locationSearchTable.mapSearchProtocolDelegate = self
        
        locationSearchController = UISearchController(searchResultsController: locationSearchTable)
        locationSearchController?.searchResultsUpdater = locationSearchTable
        
        
        
        // configure the search bar, and embed it within the navigation bar
        let searchBar = locationSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        self.navigationItem.titleView = locationSearchController?.searchBar
        
        // configure the uisearch controller appearence
        locationSearchController?.hidesNavigationBarDuringPresentation = false
        locationSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// CLLocationManager Delegate
extension MapViewController : CLLocationManagerDelegate {
    // when user respond to the permission dialogue
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            self.locationManager.requestLocation()
            
        }
    }
    
    // when location information comes back
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("location: \(location)")
            currentLocation = location
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            DispatchQueue.main.async {
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
    
    // print out the error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error)")
    }
}


// protocol used to make the mapView zoom in a new location according the location search results
extension MapViewController: MapSearchProtocol {
    func dropPinZoomIn(placemark: MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}


// customize the pinView
extension MapViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "go"), for: .normal)
        button.addTarget(self, action: #selector(self.testDirection), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        return renderer
    }
    
    
    func showDirectionView() {
        performSegue(withIdentifier: "showDirections", sender: self)
    }
    
    
    
    
    
    func testDirection() {
        var googleMapUrl = "https://maps.googleapis.com/maps/api/directions/json?"
        let key = "AIzaSyBuh-vmZk4PPOCO1c6ELDcxkntiLWHy4tE"
        
        print("+++++++")
        // source location
        let currentLatitude = self.coordinateDegreeString(degree: "\(self.currentLocation?.coordinate.latitude)")
        let currentLongitude = self.coordinateDegreeString(degree: "\(self.currentLocation?.coordinate.longitude)")
        
        googleMapUrl += "origin=\(currentLatitude),\(currentLongitude)"
        
        // destination
        let destLatitude = self.coordinateDegreeString(degree: "\(self.selectedPin?.coordinate.latitude)")
        let destLongitude = self.coordinateDegreeString(degree: "\(self.selectedPin?.coordinate.longitude)")
        googleMapUrl += "&destination=\(destLatitude),\(destLongitude)"
        
        googleMapUrl += "&key=\(key)"
        
        print(googleMapUrl)
        
        
        SharedNetworking.networkInstance.googleMapDirectionResults(url: googleMapUrl) {
            (routes, success) -> Void in
            print("-------------")
            if routes.count>0 {
                if let route = routes[0] as? [String: AnyObject] {
                    if let overview_polyline = route["overview_polyline"] as? [String: AnyObject] {
                        if let encodedPolyline = overview_polyline["points"] as? String {
                            
                            let polyline = DecodePolyline.polyline(withEncodedString: encodedPolyline)
                            
                            DispatchQueue.main.async {
                                self.mapView.add(polyline!)
                                // set the new map rect
                                let newMapSize = MKMapSize(width: polyline!.boundingMapRect.size.width*1.5,
                                                           height: polyline!.boundingMapRect.size.height*1.5)
                                let newMapOriginX = polyline!.boundingMapRect.origin.x
                                    + polyline!.boundingMapRect.size.width/2
                                    - newMapSize.width/2
                                let newMapOriginY = polyline!.boundingMapRect.origin.y
                                    + polyline!.boundingMapRect.size.height/2
                                    - newMapSize.height/2
                                let newMapOrigin = MKMapPoint(x: newMapOriginX, y: newMapOriginY)
                                let newMapRect = MKMapRect(origin: newMapOrigin, size: newMapSize)
                                self.mapView.setVisibleMapRect(newMapRect, animated: true)
                            }
                            
                        }
                    }
                }
                
            }
        }
        
        
    }
    
    // convert the coordinate degree into string
    func coordinateDegreeString(degree: String) -> String {
        var result = degree
        print("degree:\(degree)")
        let start = result.index(result.startIndex, offsetBy: 9)
        let end = result.index(result.endIndex, offsetBy: -1)
        let range = start..<end
        print(result)
        result = result.substring(with: range)
        return result
    }
    
    
    func getDirections(){
        guard let currentLocation = self.currentLocation,
            let selectedPin = self.selectedPin else{
                return
        }
        print("----------------------")
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: currentLocation.coordinate, addressDictionary: nil))
        request.destination = MKMapItem(placemark: selectedPin)
        request.requestsAlternateRoutes = true
        request.transportType = .any
        
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            
            
            for route in unwrappedResponse.routes {
                print(route.advisoryNotices)
                print(route.distance)
                print(route.name)
                print(route.steps)
                print(route.transportType)
                print(route.expectedTravelTime)
                print("-------+++++++++++++")
                self.mapView.add(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
        
    }
    
    
}








