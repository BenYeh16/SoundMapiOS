//
//  MapViewController.swift
//  SoundMap
//
//  Created by 胡采思 on 10/06/2017.
//  Copyright © 2017 cnl4. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!

    
    
    
    @IBAction func PinBtn(_ sender: Any) {
        currentLocation = locationManager.location!
        showAlert(title: "PinBtn Pushed", message: "Pining a pin on current location", btnstr: "Close Alert GCD")
        
        
        longitudeLabel.text = "\(currentLocation.coordinate.longitude)"
        latitudeLabel.text = "\(currentLocation.coordinate.latitude)"
        
        let circle = MKCircle(center: currentLocation.coordinate, radius: 300)
        mapView.add(circle)
        
        let nowAnnotation = MKPointAnnotation()
        nowAnnotation.coordinate = currentLocation.coordinate;
        nowAnnotation.title = "Now";
        mapView.addAnnotation(nowAnnotation)
        
    }
    
    var locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 2. 配置 locationManager
        locationManager.delegate = self as? CLLocationManagerDelegate;
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        // 3. 配置 mapView
        mapView.delegate = self as? MKMapViewDelegate
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        // 4. 加入測試數據
        setupData()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.PinBtn(_:)),name:NSNotification.Name(rawValue: "stopSoundNotification"), object: nil)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 1. 還沒有詢問過用戶以獲得權限
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
            // 2. 用戶不同意
        else if CLLocationManager.authorizationStatus() == .denied {
            showAlert(title: "Hello  Coders", message: "Location services were previously denied. Please enable location services for this app in Settings.", btnstr: "Close Alert")
            
        }
            // 3. 用戶已經同意
        else if CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
        currentLocation = locationManager.location!
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupData() {
        // 1. 檢查系統是否能夠監視 region
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            
            // 2.準備 region 會用到的相關屬性
            let title = "GCD's Kitchen"
            let coordinate = CLLocationCoordinate2DMake(25.024124, 121.5417615)
            let regionRadius = 300.0
            
            // 3. 設置 region 的相關屬性
            let region = CLCircularRegion(
                center: CLLocationCoordinate2D(
                    latitude: coordinate.latitude,
                    longitude: coordinate.longitude),
                radius: regionRadius,
                identifier: title)
            locationManager.startMonitoring(for: region)
            
            // 5. 繪製一個圓圈圖形（用於表示 region 的範圍）
            let circle = MKCircle(center: coordinate, radius: regionRadius)
            mapView.add(circle)
            
            
            
            
            // 4. 創建大頭釘(annotation)
            let restaurantAnnotation = MKPointAnnotation()
            restaurantAnnotation.coordinate = coordinate;
            restaurantAnnotation.title = "\(title)";
            mapView.addAnnotation(restaurantAnnotation)
            
            
            
        }
        else {
            print("System can't track regions")
        }
    }
    
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.strokeColor = UIColor.red
        
        circleRenderer.lineWidth = 2.0
        
        return circleRenderer
    }
    
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        showAlert(title: "Entering", message: "enter \(region.identifier)", btnstr: "I got it!")
        //showAlert("enter \(region.identifier)")
        //monitoredRegions[region.identifier] = NSDate()
    }
    
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        showAlert(title: "Leaving", message: "leaving \(region.identifier)", btnstr: "I got it!")
        //showAlert("exit \(region.identifier)")
        //monitoredRegions.removeValueForKey(region.identifier)
    }
    
    
    func showAlert (title: String, message: String,
                    btnstr: String){
        let alertController = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "\(btnstr)", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
