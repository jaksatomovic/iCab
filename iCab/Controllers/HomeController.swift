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
import CoreData


class HomeController: UIViewController {
    
    private var booking: Booking?
    
    private let locationManager = LocationManager.shared
    private var seconds = 0
    private var timer: Timer?
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var locationList: [CLLocation] = []
    private var currentObjectId: Any?
    private var _isStarted: Bool = false
    private var _from: String = ""
    private var _to: String = ""
    private var _seats: String = ""

    
    var fromTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.clipsToBounds = true
        tf.layer.cornerRadius = 10
        tf.textAlignment = .left
        tf.textColor = .black
        tf.placeholder = "From:"
//        tf.text = "Heinzelova 62A"
        tf.textAlignment = .left
        tf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return tf
    }()
    
    var toTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.clipsToBounds = true
        tf.layer.cornerRadius = 10
        tf.textAlignment = .left
        tf.textColor = .black
        tf.placeholder = "To:"
//        tf.text = "Maksimirska 23"
        tf.textAlignment = .left
        tf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return tf
    }()
    
    var seatNumberTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.clipsToBounds = true
        tf.layer.cornerRadius = 10
        tf.textAlignment = .left
        tf.textColor = .black
//        tf.text = "1"
        tf.placeholder = "4"
        tf.textAlignment = .center
        tf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return tf
    }()
    
    var startButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .green
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitle("Start ride", for: .normal)
        btn.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        return btn
    }()
    
    var pickedButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .black
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitle("Passenger picked up", for: .normal)
        btn.addTarget(self, action: #selector(pickedUpTapped), for: .touchUpInside)
        return btn
    }()
    
    var continueButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .black
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitle("Continue ride", for: .normal)
        btn.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        return btn
    }()
    
    var pauseButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .darkGray
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitle("Stop-over", for: .normal)
        btn.addTarget(self, action: #selector(pauseTapped), for: .touchUpInside)
        return btn
    }()
    
    var stopButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .red
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
        mapView.showsUserLocation = true
        startLocationUpdates()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    
    func setupViews() {
        view.addSubview(mapView)
        view.addSubview(fromTextField)
        view.addSubview(toTextField)
        view.addSubview(seatNumberTextField)
        view.addSubview(startButton)
        view.addSubview(stopButton)
        view.addSubview(pauseButton)
        view.addSubview(pickedButton)
        view.addSubview(continueButton)

        mapView.fillSuperview()
        
        fromTextField.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: toTextField.topAnchor, right: view.rightAnchor, topConstant: 50, leftConstant: 24, bottomConstant: 5, rightConstant: 24, widthConstant: 0, heightConstant: 50)
        
        toTextField.anchor(fromTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: toTextField.leftAnchor, topConstant: 0, leftConstant: 32, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
        seatNumberTextField.anchor(fromTextField.bottomAnchor, left: toTextField.rightAnchor, bottom: nil, right: view.rightAnchor, topConstant: 5, leftConstant: 5, bottomConstant: 0, rightConstant: 32, widthConstant: 50, heightConstant: 50)
        
        
        startButton.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 45)
        pickedButton.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 45)
        stopButton.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.centerXAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 45)
        continueButton.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 45)
        pauseButton.anchor(nil, left: view.centerXAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 45)
        
        startButton.isHidden = true
        stopButton.isHidden = true
        pickedButton.isHidden = true
        pauseButton.isHidden = true
        continueButton.isHidden = true

    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func eachSecond() {
        seconds += 1
    }
    
    private func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.activityType = .automotiveNavigation
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        saveRide()
    }
    
    private func startRide() {
        _isStarted = true

        startButton.isHidden = true
        pickedButton.isHidden = false
        mapView.removeOverlays(mapView.overlays)
        
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.eachSecond()
        }
        saveRide()
    }
    
    private func stopRide() {
        _isStarted = false
        
        startButton.isHidden = false
        stopButton.isHidden = true
        pauseButton.isHidden = true

        locationManager.stopUpdatingLocation()
    }
  
    private func saveRide() {

        var parameters : NSDictionary!
        
        let newBooking = Booking(context: CoreDataManager.context)
        newBooking.distance = distance.value
        newBooking.duration = Int16(seconds)
        newBooking.time = Date()
        newBooking.status = ""
        
        for location in locationList {
            let locationObject = Location(context: CoreDataManager.context)
            locationObject.timestamp = location.timestamp
            locationObject.latitude = location.coordinate.latitude
            locationObject.longitude = location.coordinate.longitude
            newBooking.addToLocations(locationObject)
        }
        
        CoreDataManager.saveContext()
        
        booking = newBooking
        currentObjectId = booking?.objectID
        parameters = [
            "bookingId" : "\(getAutoIncremenet(currentObjectId as! NSManagedObjectID))",
            "status" : "started",
            "time" : "\(booking?.time as Any)",
            "lat" : locationList.last?.coordinate.latitude as Any,
            "lng" : locationList.last?.coordinate.longitude as Any
        ]
        
        sendBookingData(parameters)
    }
    
    private func changeStatus(_ message: String) {
        var parameters : NSDictionary!
        var object: Booking!
        let context = CoreDataManager.context

        do {
            object = try context.existingObject(with: currentObjectId as! NSManagedObjectID) as! Booking
            object.status = message
        } catch {
            print("Can't find object...")
        }
        
        CoreDataManager.saveContext()
                
        parameters = [
            "bookingId" : "\(getAutoIncremenet(currentObjectId as! NSManagedObjectID))",
            "status" : "\(object.status as Any)",
            "time" : "\(object?.time as Any)",
            "lat" : locationList.last?.coordinate.latitude as Any,
            "lng" : locationList.last?.coordinate.longitude as Any
        ]
        
        sendBookingData(parameters)
    }
    
    func getAutoIncremenet(_ objectID: NSManagedObjectID) -> Int64   {
        let url = objectID.uriRepresentation()
        let urlString = url.absoluteString
        if let pN = urlString.components(separatedBy: "/").last {
            let numberPart = pN.replacingOccurrences(of: "p", with: "")
            if let number = Int64(numberPart) {
                return number
            }
        }
        return 0
    }
    
}

// MARK: - Actions

extension HomeController {
    
    @objc func startTapped() {
        startRide()
    }
    
    @objc func pauseTapped() {
        continueButton.isHidden = false
        pickedButton.isHidden = true
        stopButton.isHidden = true
        pauseButton.isHidden = true
        changeStatus("paused")
    }
    
    @objc func continueTapped() {
        continueButton.isHidden = true
        stopButton.isHidden = false
        pauseButton.isHidden = false
        changeStatus("continued")
    }
    
    @objc func pickedUpTapped() {
        pickedButton.isHidden = true
        stopButton.isHidden = false
        pauseButton.isHidden = false
        changeStatus("pickedUp")
    }

    
    @objc func stopTapped() {
        let alertController = UIAlertController(title: "End ride?",
                                                message: "Do you wish to end your ride?",
                                                preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
            self.stopRide()
            self.saveRide()
            let vc = DetailController()
            vc.booking = self.booking
            self.show(vc, sender: self)
        })
        
        present(alertController, animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        let annotation = MKPointAnnotation()
        

        if (textField == fromTextField) {
            _from = textField.text!
        }
        if (textField == toTextField) {
            _to = textField.text!
        }
        if (textField == seatNumberTextField) {
            _seats = textField.text!
        }
        if (_seats != "" && _to != "" && _from != "") {
            startButton.isHidden = false
            let address = _to
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(address) { (placemarks, error) in
                guard
                    let placemarks = placemarks,
                    let location = placemarks.first?.location
                    
                else {
                        print("nothing found...")
                        return
                }
                annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                self.mapView.addAnnotation(annotation)
                // Use your location
            }
        }
    }
}

// MARK: - Location Manager Delegate

extension HomeController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 15 && abs(howRecent) < 10 else { continue }
            
            if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
                let coordinates = [lastLocation.coordinate, newLocation.coordinate]
                mapView.add(MKPolyline(coordinates: coordinates, count: 2))
                let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 500, 500)
                mapView.setRegion(region, animated: true)
            }
            if _isStarted == true {
                sendGPSData(newLocation)
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

// MARK: - API

extension HomeController {
    
    func sendBookingData(_ parameters : NSDictionary) {
        
        let url : String = "https://test.mother.i-ways.hr?json=1"
        print(parameters)
        Alamofire.request(url, method: .post, parameters: parameters as? [String : AnyObject], encoding: JSONEncoding.default).responseString { response in
            print(response)
            switch response.result {
            case .success(let value):
                if let httpStatusCode = response.response?.statusCode {
                    if httpStatusCode == 200 {
                        print("VALUE: \(value)")
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func sendGPSData(_ location: CLLocation) {
        
        let url : String = "https://test.mother.i-ways.hr?json=1"
        var parameters : NSDictionary!

        parameters = [
            "bookingId" : "\(getAutoIncremenet(currentObjectId as! NSManagedObjectID))",
            "time" : "\(Date())",
            "lat" : location.coordinate.latitude,
            "lng" : location.coordinate.longitude
        ]
        print(parameters)
        Alamofire.request(url, method: .post, parameters: parameters as? [String : AnyObject], encoding: JSONEncoding.default).responseString { response in
            print(response)
            switch response.result {
            case .success(let value):
                if let httpStatusCode = response.response?.statusCode {
                    if httpStatusCode == 200 {
                        print("VALUE: \(value)")
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

