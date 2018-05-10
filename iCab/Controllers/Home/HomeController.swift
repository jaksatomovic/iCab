//
//  HomeController.swift
//  iCab
//
//  Created by Jaksa Tomovic on 10/05/2018.
//  Copyright © 2018 Jakša Tomović. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire
import CoreLocation
import MapKit

class HomeController: UIViewController {
    
    private var booking: Booking?
    
    private let locationManager = LocationManager.shared
    private var seconds = 0
    private var timer: Timer?
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var locationList: [CLLocation] = []
    
    var fromTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.clipsToBounds = true
        tf.layer.cornerRadius = 10
        tf.textAlignment = .left
        tf.textColor = .black
        tf.placeholder = "  From: "
        return tf
    }()
    
    var toTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.clipsToBounds = true
        tf.layer.cornerRadius = 10
        tf.textAlignment = .left
        tf.textColor = .black
        tf.placeholder = "  To: "
        return tf
    }()
    
    var seatNumberTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.clipsToBounds = true
        tf.layer.cornerRadius = 10
        tf.textAlignment = .left
        tf.textColor = .black
        tf.placeholder = "  4 "
        return tf
    }()
    
    var startButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .green
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 10
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitle("Start ride", for: .normal)
        btn.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        return btn
    }()
    
    var pauseButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .darkGray
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 10
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitle("Pause ride", for: .normal)
//        btn.addTarget(self, action: #selector(stopTapped), for: .touchUpInside)
        return btn
    }()
    
    var stopButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .red
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 10
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitle("Stop ride", for: .normal)
        btn.addTarget(self, action: #selector(stopTapped), for: .touchUpInside)
        return btn
    }()

    
    var mapView: MKMapView = {
        let view = MKMapView()
        return view
    }()
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        mapView.delegate = self
    }
    
    
    func eachSecond() {
        seconds += 1
    }
    
    func setupViews() {
        view.addSubview(mapView)
        view.addSubview(fromTextField)
        view.addSubview(toTextField)
        view.addSubview(seatNumberTextField)
        view.addSubview(startButton)
        view.addSubview(stopButton)
        view.addSubview(pauseButton)


        mapView.fillSuperview()
        
        fromTextField.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: toTextField.topAnchor, right: view.rightAnchor, topConstant: 50, leftConstant: 24, bottomConstant: 5, rightConstant: 24, widthConstant: 0, heightConstant: 50)
        
        toTextField.anchor(fromTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: toTextField.leftAnchor, topConstant: 0, leftConstant: 32, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
        seatNumberTextField.anchor(fromTextField.bottomAnchor, left: toTextField.rightAnchor, bottom: nil, right: view.rightAnchor, topConstant: 5, leftConstant: 5, bottomConstant: 0, rightConstant: 32, widthConstant: 50, heightConstant: 50)
        
        
        startButton.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 24, bottomConstant: 8, rightConstant: 24, widthConstant: 0, heightConstant: 45)
        stopButton.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.centerXAnchor, topConstant: 0, leftConstant: 24, bottomConstant: 8, rightConstant: 6, widthConstant: 0, heightConstant: 45)
        pauseButton.anchor(nil, left: view.centerXAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 6, bottomConstant: 8, rightConstant: 24, widthConstant: 0, heightConstant: 45)
        
        startButton.isHidden = false
        stopButton.isHidden = true
        pauseButton.isHidden = true
        
    }
    
    private func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.activityType = .automotiveNavigation
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
    }
    
    private func startRun() {
        startButton.isHidden = true
        stopButton.isHidden = false
        pauseButton.isHidden = false
        mapView.removeOverlays(mapView.overlays)
        
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.eachSecond()
        }
        startLocationUpdates()
    }
    
    private func stopRun() {
        startButton.isHidden = false
        stopButton.isHidden = true
        
        locationManager.stopUpdatingLocation()
    }
  
    private func saveRun() {
        let newBooking = Booking(context: CoreDataManager.context)
        newBooking.distance = distance.value
        newBooking.duration = Int16(seconds)
        newBooking.time = Date()
        
        for location in locationList {
            let locationObject = Location(context: CoreDataManager.context)
            locationObject.timestamp = location.timestamp
            locationObject.latitude = location.coordinate.latitude
            locationObject.longitude = location.coordinate.longitude
            newBooking.addToLocations(locationObject)
        }
        
        CoreDataManager.saveContext()
        
        booking = newBooking
    }
    
}

extension HomeController {
    
    @objc func startTapped() {
        startRun()
    }
    
    @objc func stopTapped() {
        let alertController = UIAlertController(title: "End run?",
                                                message: "Do you wish to end your run?",
                                                preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            self.stopRun()
            self.saveRun()
            self.show(DetailController(), sender: self)
        })
        alertController.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
            self.stopRun()
            _ = self.navigationController?.popToRootViewController(animated: true)
        })
        
        present(alertController, animated: true)
    }
}

// MARK: - Location Manager Delegate

extension HomeController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
            
            if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
                let coordinates = [lastLocation.coordinate, newLocation.coordinate]
                mapView.add(MKPolyline(coordinates: coordinates, count: 2))
                let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 500, 500)
                mapView.setRegion(region, animated: true)
            }
            
            locationList.append(newLocation)
        }
    }
}

// MARK: - Map View Delegate

extension HomeController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .blue
        renderer.lineWidth = 3
        return renderer
    }
}

