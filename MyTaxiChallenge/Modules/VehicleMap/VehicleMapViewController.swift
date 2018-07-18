//
//  VehicleMapViewController.swift
//  MyTaxiChallenge
//
//  Created by Ricardo Abel Martinez Vivanco on 7/17/18.
//  Copyright © 2018 Ricardo Abel Martinez Vivanco. All rights reserved.
//

import UIKit
import MapKit
import NVActivityIndicatorView

class VehicleMapViewController: UIViewController {

    // MARK: - Properties
    
    var activityIndicator: NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRect.zero)
    @IBOutlet private weak var mapView: MKMapView!
    
    lazy var viewModel: VehicleMapViewModel = {
        return VehicleMapViewModel()
    }()
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureActivityIndicator()
        initViewModel()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        self.navigationItem.title = "Vehicles Near Me"
    }
    
    private func configureActivityIndicator() {
        let frame = CGRect(x: view.center.x, y: view.center.y, width: 100, height: 100)
        activityIndicator = NVActivityIndicatorView(frame: frame, type: .ballScaleRippleMultiple, color: UIColor.white)
        activityIndicator.center = CGPoint(x: view.center.x, y: view.center.y)
        activityIndicator.isHidden = true
        view.addSubview(activityIndicator)
    }
    
    private func initViewModel() {
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                if let message = strongSelf.viewModel.alertMessage {
                    strongSelf.showAlert( message )
                }
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                let isLoading = strongSelf.viewModel.isLoading
                if isLoading {
                    strongSelf.activityIndicator.isHidden = false
                    strongSelf.activityIndicator.startAnimating()
                }else {
                    strongSelf.activityIndicator.isHidden = true
                    strongSelf.activityIndicator.stopAnimating()
                }
            }
        }
        
        viewModel.reloadAnnotations = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.addVehiclesToMap(list: strongSelf.viewModel.getVehicleAnnotationViewModels())
            }
        }
    }
    
    private func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Map View Related Code

extension VehicleMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
        
        let pinImage = UIImage(named: "customPinImage")
        annotationView!.image = pinImage
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        updateListOfCars()
    }
    
    private func updateListOfCars(){
        let northEast = mapView.convert(CGPoint(x: mapView.bounds.width, y: 0), toCoordinateFrom: mapView)
        let southWest = mapView.convert(CGPoint(x: 0, y: mapView.bounds.height), toCoordinateFrom: mapView)
        
        let nePoint = CLLocation(latitude: northEast.latitude, longitude: northEast.longitude)
        let swPoint = CLLocation(latitude: southWest.latitude, longitude: southWest.longitude)
        viewModel.getVehicles(at: nePoint, swPoint: swPoint)
    }
    
    private func addVehiclesToMap(list: [VehicleAnnotationViewModel]) {
        mapView.removeAnnotations(mapView.annotations)
        for vehicleAnnotation in list {
            
            let myAnnotation = MKPointAnnotation()
            myAnnotation.coordinate = CLLocationCoordinate2DMake(vehicleAnnotation.lat, vehicleAnnotation.lon)
            myAnnotation.title = vehicleAnnotation.id
            mapView.addAnnotation(myAnnotation)
        }
    }
}

// MARK: - VehicleAnnotation Declaration

class VehicleAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var image: UIImage
    var title: String?
    
    init(with coordinate: CLLocationCoordinate2D, image: UIImage, title: String = ""){
        self.coordinate = coordinate
        self.image = image
    }
}

