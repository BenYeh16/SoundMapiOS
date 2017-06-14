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

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    
    
    var locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    
    let data = SharedData()
    var pins = [[String : AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 2. 配置 locationManager
        locationManager.delegate = self as? CLLocationManagerDelegate;
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        // 3. 配置 mapView
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        // 4. 加入測試數據
        setupData()
        // Do any additional setup after loading the view, typically from a nib.

        
        // 5. 跟 Server 拿 Pin 的資料
        getNearByPin()
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
        //currentLocation = locationManager.location!
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getNearByPin() {
        //currentLocation = locationManager.location!
        
        //let url = data.getNearByPin(latitude: "\(currentLocation.coordinate.latitude)", longitude: "\(currentLocation.coordinate.longitude)");
        
        // Mock Position for Testing
        
        let url = data.getNearByPin(latitude: "12", longitude: "13")
        
        if ( url.isEmpty ) {
            print("url is empty");
        } else {
            let session = URLSession(configuration: .default);
            let loginSession = session.dataTask(with: URL(string: url)!) { (data, response, error) in
                if let e = error {
                    print("Error retrieving nearby pin: \(e)")
                } else {
                    if (response as? HTTPURLResponse) != nil {
                        if data != nil {
                            do  {
                                self.pins.removeAll()
                                
                                let jsonData = try JSONSerialization.jsonObject(with: data!) as! [String: Any]
                                let parsedDatas = jsonData["result"] as! [[String: Any]]
                                
                                for i in 0 ..< parsedDatas.count {
                                    
                                    let sound_id = parsedDatas[i]["sound_id"] as! String
                                    
                                    // TODO : Save Datas into Dictionary
                                    /*
                                    self.pins.append(soundID:)
                                    
                                    self.pins[sound_id]["description"] = parsedDatas[i]["description"] as! String
                                    self.pins[sound_id]["sound_id"] = parsedDatas[i]["sound_id"] as! String
                                    self.pins[sound_id]["title"] = parsedDatas[i]["title"] as! String
                                    self.pins[sound_id]["user_id"] = parsedDatas[i]["longitude"] as! Float
                                    self.pins[sound_id]["date"] = parsedDatas[i]["date"] as! String
                                    self.pins[sound_id]["tag"] = parsedDatas[i]["tag"] as! String
                                    self.pins[sound_id]["latitude"] = parsedDatas[i]["latitude"] as! Float
                                    */
                                
                                }
                                
                                //print (String(data: data!, encoding: String.Encoding.utf8) as String!)
                            } catch let error as Error{
                                print (error)
                            }
                        } else {
                            print("Couldn't get data: Data is nil")
                        }
                    } else {
                        print("Couldn't get response code for some reason")
                    }
                }
            }
            loginSession.resume();
        }
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
    
    // Customize annotation: music icon
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // Don't want to show a custom image if the annotation is the user's location.
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        if let annotationView = annotationView {
            // Disable callout, popover will handle
            annotationView.canShowCallout = false
            
            // Resize image
            let pinImage = UIImage(named: "map-pin")
            let size = CGSize(width: 40, height: 40)
            UIGraphicsBeginImageContext(size)
            pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            annotationView.image = resizedImage
        }
        
        return annotationView
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
    
    
    /****** Popover related ******/
    
    // UIPopoverPresentationControllerDelegate method
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        // Force popover style
        return UIModalPresentationStyle.none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapPopup" {
            let destinationVC = segue.destination as! MapPopupViewController
            
            // TODO: Get data from server
            //
            //
            
            // TODO: Pass data
            destinationVC.tmpOwner = "ChelseaHu"
            destinationVC.tmpTitle = "MyVoice"
            destinationVC.tmpDescript = "Listen to my lovely sound"
            destinationVC.tmpImage = #imageLiteral(resourceName: "music-play")
            destinationVC.soundURL = "xxx"
            
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        
        performSegue(withIdentifier: "mapPopup", sender: nil)
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
