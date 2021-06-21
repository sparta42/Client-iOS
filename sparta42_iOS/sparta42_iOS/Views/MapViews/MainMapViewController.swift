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
    
    lazy var httpClient: HTTPClient = {
        let client = HTTPClient(baseUrl: " https://sparta42be.s3.ap-northeast-2.amazonaws.com/friends.json")
        return client
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
    
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        let region = MKCoordinateRegion(center: self.mapKitView.centerCoordinate, span: span)
        self.mapKitView.setRegion(region, animated: true)
        

    }
    
    

}

extension MainMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let span = mapKitView.region.span
        let center = mapKitView.region.center
        
        let farSouth = CLLocation(latitude: center.latitude - span.latitudeDelta * 0.5, longitude: center.longitude)
        let farNorth = CLLocation(latitude: center.latitude + span.latitudeDelta * 0.5, longitude: center.longitude)
        let farEast = CLLocation(latitude: center.latitude, longitude: center.longitude + span.longitudeDelta * 0.5)
        let farWest = CLLocation(latitude: center.latitude, longitude: center.longitude + span.longitudeDelta * 0.5)
        
        let minimumLatitude: Double = farSouth.coordinate.latitude
        let maximumLatitude: Double = farNorth.coordinate.latitude
        let minimumlongtitude: Double = farWest.coordinate.longitude
        let maximumLongitude: Double = farEast.coordinate.longitude
            
        print ("minimumLatitude: \(minimumLatitude)")
        print ("maximumLatitude: \(maximumLatitude)")
        print ("minimumLongitude: \(minimumlongtitude)")
        print ("maximumLongitude: \(maximumLongitude)")
        
        
        showFriendsOnMap()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
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
        
        httpClient.getJson(
            path:"https://raw.githubusercontent.com/ChoiKanghun/images/master/friends.json",
            params: ["email": "nil"]) { result in
            if let json = try? result.get(),
               let data = json.data(using: .utf8) {
                if let friendsList =  try? JSONDecoder().decode(FriendsList.self, from: data) {
                    
                    for i in friendsList.friends.indices {
                        let friend = friendsList.friends[i]
                        let friendAnnotation = FriendAnnotation()
                        let cooridinate = CLLocationCoordinate2D(latitude: friend.latitude, longitude: friend.longitude)
                        friendAnnotation.coordinate = cooridinate
                        friendAnnotation.title = friend.title
                        friendAnnotation.imageName = friend.imageUrl
                        friendAnnotation.reuseIdentifier = String(friend.id)
                        self.mapKitView.addAnnotation(friendAnnotation)
                    }
                    
                }
                else {
                    print("can't decode friendsList")
                }
            }
            else {
                print("can't convert json")
            }
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
        ImageLoader.load64pxImage(url: annotation.imageName!) { image in
            friendMapView?.image = image
        }
        
        
        
        return friendMapView
    }
    

}
