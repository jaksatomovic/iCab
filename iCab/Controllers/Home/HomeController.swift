//
//  HomeController.swift
//  iCab
//
//  Created by Jaksa Tomovic on 10/05/2018.
//  Copyright © 2018 Jakša Tomović. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import CodableAlamofire

class HomeController: UIViewController, GMSMapViewDelegate {
    
    
    
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
    
    var mainButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .green
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 10
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitle("Start ride", for: .normal)
        btn.tag = 0
        return btn
    }()

    
    lazy var mapView: GMSMapView = {
        let view = GMSMapView()
        view.delegate = self
        return view
    }()
    
    
    fileprivate var locationMarker : GMSMarker? = GMSMarker()
    
    let lat = 42.95289
    let long = 17.149889
    let zoom: Float = 13
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        createMapView()
    }
    
    func setupViews() {
        view.addSubview(mapView)
        view.addSubview(fromTextField)
        view.addSubview(toTextField)
        view.addSubview(seatNumberTextField)
        view.addSubview(mainButton)

        mapView.fillSuperview()
        
        fromTextField.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: toTextField.topAnchor, right: view.rightAnchor, topConstant: 50, leftConstant: 24, bottomConstant: 5, rightConstant: 24, widthConstant: 0, heightConstant: 50)
        
        toTextField.anchor(fromTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: toTextField.leftAnchor, topConstant: 0, leftConstant: 32, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
        seatNumberTextField.anchor(fromTextField.bottomAnchor, left: toTextField.rightAnchor, bottom: nil, right: view.rightAnchor, topConstant: 5, leftConstant: 5, bottomConstant: 0, rightConstant: 32, widthConstant: 50, heightConstant: 50)
        
        mainButton.anchor(nil, left: view.centerXAnchor, bottom: view.bottomAnchor, right: nil, topConstant: 0, leftConstant: -60, bottomConstant: 8, rightConstant: 0, widthConstant: 120, heightConstant: 45)
        
        mapView.settings.myLocationButton = true
        
        
        
//        self.mapView.mapStyle(withFilename: "paper", andType: "json")
    }
    
    func createMapView() {
        let camera = GMSCameraPosition.camera(withLatitude:lat, longitude: long, zoom: zoom)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
    }
    

    
    private func setMapCamera() {
        CATransaction.begin()
        CATransaction.setValue(2, forKey: kCATransactionAnimationDuration)
        mapView.animate(to: GMSCameraPosition.camera(withLatitude: 42.954282, longitude: 17.130729, zoom: 15))
        CATransaction.commit()
    }
    
   
    
    //MARK: GMSMapViewDelegate Methods
//    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//
//        locationMarker = marker
//        infoWindow.removeFromSuperview()
//        infoWindow = loadNiB()
//        guard let location = locationMarker?.position else {
//            print("locationMarker is nil")
//            return false
//        }
//        //        infoWindow.spotData = markerData
//        infoWindow.delegate = self
//        infoWindow.alpha = 0.9
//        infoWindow.layer.cornerRadius = 12
//        infoWindow.layer.borderWidth = 2
//        infoWindow.layer.borderColor = Pallete.palette_blue.cgColor
//        infoWindow.infoButton.layer.cornerRadius = infoWindow.infoButton.frame.height / 2
//
//
//        infoWindow.titleLabel.text = "Tomovic Holiday Apartments"
//        infoWindow.priceRange.rating = 3
//        infoWindow.center = mapView.projection.point(for: location)
//        infoWindow.center.y = infoWindow.center.y - 82
//        self.view.addSubview(infoWindow)
//        return false
//    }
    
//    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
//        if (locationMarker != nil){
//            guard let location = locationMarker?.position else {
//                print("locationMarker is nil")
//                return
//            }
//            infoWindow.center = mapView.projection.point(for: location)
//            infoWindow.center.y = infoWindow.center.y - 82
//        }
//    }
    
//    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
//        infoWindow.removeFromSuperview()
//    }

    
}

