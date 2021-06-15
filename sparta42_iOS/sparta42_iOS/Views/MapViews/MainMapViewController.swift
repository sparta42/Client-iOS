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
    }
    
    
    private func getLocationUsagePermission() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    private func initializeMapView() {
        self.mapKitView.mapType = MKMapType.standard
        self.mapKitView.showsUserLocation = true
        self.mapKitView.setUserTrackingMode(.follow, animated: true)
    }
    

}

extension MainMapViewController: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        
//        guard let location = locations.last
//        else { return }
//        let latitude = location.coordinate.latitude
//        let longtitude = location.coordinate.longitude
//        
//        
//        
//    }
//    
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
}
