//
//  MainMapViewController.swift
//  sparta42_iOS
//
//  Created by 최강훈 on 2021/06/15.
//

import UIKit
import CoreLocation
import MapKit

class MainMapViewController: UIViewController {

    @IBOutlet weak var mapKitView: MKMapView!
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation() // startUpdate를 해야 didUpdateLocation 메서드가 호출됨.
        manager.delegate = self
        return manager
    }()
    
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.locationManager.stopUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getLocationUsagePermission()
        initializeMapView()
        
        
        showFriendsOnMap()
    }
    
    private func getLocationUsagePermission() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    private func initializeMapView() {
        self.mapKitView.mapType = MKMapType.standard
        self.mapKitView.showsUserLocation = true
        self.mapKitView.setUserTrackingMode(.follow, animated: true)
        self.mapKitView.delegate = self
    
        let span = MKCoordinateSpan(latitudeDelta: 0.0001, longitudeDelta: 0.0001)
        let region = MKCoordinateRegion(center: self.mapKitView.centerCoordinate, span: span)
        self.mapKitView.setRegion(region, animated: true)
        

    }
    
    

}

extension MainMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    
        
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정 됨")
        case .restricted, .notDetermined, .denied:
            DispatchQueue.main.async {
                print("GPS 이용 권한 없음. 재요청...")
                self.getLocationUsagePermission()
            }
        default:
            print("GPS Default")
        }
        
    }
    
    func showFriendsOnMap() {
        
        let points = [CLLocationCoordinate2D(latitude: 37.488588, longitude: 127.066856), CLLocationCoordinate2D(latitude: 37.487703, longitude: 127.067071)]
        let titles = ["kchoi", "nakim"]
        let imageUrls = ["https://user-images.githubusercontent.com/41955126/122517706-54dfa680-d04b-11eb-8c73-868f5acb53db.png","https://user-images.githubusercontent.com/41955126/122518736-8c9b1e00-d04c-11eb-9d18-d6e4390ab425.png"]
        
        for i in points.indices {
            let friendAnnotation = FriendAnnotation()
            friendAnnotation.coordinate = points[i]
            friendAnnotation.title = titles[i]
            friendAnnotation.imageName = imageUrls[i]
            friendAnnotation.reuseIdentifier = titles[i]
            self.mapKitView.addAnnotation(friendAnnotation)
        }
        

    }
    
    
    
}

extension MainMapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if !(annotation is FriendAnnotation) { return nil }
        
        guard let annotation = annotation as? FriendAnnotation,
              let reuseIdentifier = annotation.reuseIdentifier
        else { print("not friend annotation"); return nil}
        
        var friendMapView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        if friendMapView == nil {
            friendMapView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            friendMapView?.canShowCallout = true
        }
        else {
            friendMapView!.annotation = annotation
        }
        let url = URL(string: annotation.imageName!)
        let data = try? Data(contentsOf: url!)
        let image = UIImage(data: data!)
        friendMapView?.image = image
        
        return friendMapView
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        guard !annotation.isKind(of: MKUserLocation.self)
//        else {
//            print("is MKUserLocation")
//            return nil }
//
//        var annotationView: MKAnnotationView?
//
//        let friendAnnotation = annotation as? FriendAnnotation
//        annotationView = setupFriendAnnotationView(for: friendAnnotation!, on: self.mapKitView)
//
//        return annotationView
//    }
//
//
//    func setupFriendAnnotationView(for annotation: FriendAnnotation, on mapView: MKMapView) -> MKAnnotationView {
//        let reuseIdentifier = "test"
//        let friendAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
//
//
//        let url = URL(string: annotation.imageUrl!)
//        let data = try? Data(contentsOf: url!)
//        let userProfileImage = UIImage(data: data!)
//        friendAnnotationView!.image = userProfileImage
//
//        return friendAnnotationView!
//    }
}
