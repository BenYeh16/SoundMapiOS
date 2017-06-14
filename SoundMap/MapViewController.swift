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

    var refreshButton: UIButton! = nil
    var annotationArray: Array<MKPointAnnotation> = []
    @IBAction func PinBtn(_ sender: Any) {
        currentLocation = locationManager.location!
        //showAlert(title: "PinBtn Pushed", message: "Pining a pin on current location", btnstr: "Close Alert GCD")
        
        
        longitudeLabel.text = "\(currentLocation.coordinate.longitude)"
        latitudeLabel.text = "\(currentLocation.coordinate.latitude)"
        
        //let circle = MKCircle(center: currentLocation.coordinate, radius: 300)
        //mapView.add(circle)
        
        /*
        let nowAnnotation = MKPointAnnotation()
        nowAnnotation.coordinate = currentLocation.coordinate;
        nowAnnotation.title = "Now";
        mapView.addAnnotation(nowAnnotation)*/
        
    }
    
    var locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    
    let data = SharedData()
    var pins = [[String : AnyObject]]()
    var descriptDict = [String : String]()
    var titleDict = [String : String]()
    var ownerDict = [String : String]()
    var latitudeDict = [String : CLLocationDegrees]()
    var longitudeDict = [String : CLLocationDegrees]()
    var soundIDDict = [CLLocationDegrees: String]()
    
    var target: String = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshButton()
        // 2. 配置 locationManager
        locationManager.delegate = self as? CLLocationManagerDelegate;
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        // 3. 配置 mapView
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        // 4. 加入測試數據
        // setupData()
        // Do any additional setup after loading the view, typically from a nib.

        
        // 5. 跟 Server 拿 Pin 的資料
        getNearByPin()
        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.PinBtn(_:)),name:NSNotification.Name(rawValue: "stopSoundNotification"), object: nil)

    }
    
    func setupRefreshButton(){
        refreshButton = UIButton(frame: CGRect(x: 250, y: 250, width: 50, height: 50))
        refreshButton.backgroundColor = UIColor.red
        refreshButton.addTarget(self, action: #selector(pressRefreshButton(button:)), for: .touchUpInside)
        self.view.addSubview(refreshButton)
    }
    
    func pressRefreshButton(button: UIButton){
        //delete old pins
        for anno in annotationArray {
            mapView.removeAnnotation(anno)
        }
        //get locations from server
        
        //draw all pins
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 1. 還沒有詢問過用戶以獲得權限
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
            // 2. 用戶不同意
        else if CLLocationManager.authorizationStatus() == .denied {
            //showAlert(title: "Hello  Coders", message: "Location services were previously denied. Please enable location services for this app in Settings.", btnstr: "Close Alert")
            
        }
            // 3. 用戶已經同意
        else if CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getNearByPin() {
        //currentLocation = locationManager.location!
        //print("\(currentLocation.coordinate.latitude)")
        //print("\(currentLocation.coordinate.longitude)")
        //let url = data.getNearByPin(latitude: "\(currentLocation.coordinate.latitude)", longitude: "\(currentLocation.coordinate.longitude)");
        // Mock Position for Testing
        
        let url = data.getNearByPin(latitude: "25.02", longitude: "121.54123")
        
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
                                print(jsonData)
                                let parsedDatas = jsonData["result"] as! [[String: Any]]
                                
                                for i in 0 ..< parsedDatas.count {
                                    
                                    let sound_id: String = parsedDatas[i]["sound_id"] as! String
                                    
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
                                    //descriptDict.append(soundID: )
                                    self.descriptDict[sound_id] = parsedDatas[i]["description"] as? String
                                    self.titleDict[sound_id] = parsedDatas[i]["title"] as? String
                                    self.ownerDict[sound_id] = parsedDatas[i]["user_id"] as? String
                                    self.latitudeDict[sound_id] = parsedDatas[i]["latitude"] as? CLLocationDegrees
                                    self.longitudeDict[sound_id] = parsedDatas[i]["longitude"] as? CLLocationDegrees

                                    self.addNewPin(latitude: self.latitudeDict[sound_id]!, longitude: self.longitudeDict[sound_id]!, ID: sound_id)
                                
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
            /*let restaurantAnnotation = MKPointAnnotation()
            restaurantAnnotation.coordinate = coordinate;
            restaurantAnnotation.title = "\(title)";

            mapView.addAnnotation(restaurantAnnotation)*/
            var sound_id: String = "24"
            self.descriptDict[sound_id] = "COme and listen"
            self.titleDict[sound_id] = "Yo"
            self.ownerDict[sound_id] = "BenYeh"
            self.latitudeDict[sound_id] = 25.0243
            self.longitudeDict[sound_id] = 121.542
            self.addNewPin(latitude: self.latitudeDict[sound_id]!, longitude: self.longitudeDict[sound_id]!, ID: sound_id)
            
            // Fake
            sound_id = "25"
            self.descriptDict[sound_id] = "I like this best song."
            self.titleDict[sound_id] = "Favorite"
            self.ownerDict[sound_id] = "Allen. L"
            self.latitudeDict[sound_id] = 25.025
            self.longitudeDict[sound_id] = 121.55
            self.addNewPin(latitude: self.latitudeDict[sound_id]!, longitude: self.longitudeDict[sound_id]!, ID: sound_id)

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
    


    func addPin(location: CLLocation) {

        
        //currentLocation = locationManager.location!
        //showAlert(title: "add pin", message: "Pining a pin on location", btnstr: "Close Alert")
        
        
        longitudeLabel.text = "\(location.coordinate.longitude)"
        latitudeLabel.text = "\(location.coordinate.latitude)"
        
        //let circle = MKCircle(center: currentLocation.coordinate, radius: 300)
        //mapView.add(circle)
        
        let nowAnnotation = MKPointAnnotation()
        nowAnnotation.coordinate = currentLocation.coordinate;
        nowAnnotation.title = "10";
        mapView.addAnnotation(nowAnnotation)
        
    }
    
    func addNewPin(latitude: CLLocationDegrees, longitude: CLLocationDegrees, ID: String) {
        let nowAnnotation = MKPointAnnotation()
        nowAnnotation.coordinate.latitude = latitude
        nowAnnotation.coordinate.longitude = longitude
        nowAnnotation.title = ID;
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
            
            
            // Pass data
            destinationVC.tmpOwner = ownerDict[target]
            destinationVC.tmpTitle = titleDict[target]
            destinationVC.tmpDescript = descriptDict[target]
            destinationVC.tmpImage = #imageLiteral(resourceName: "music-play")
            destinationVC.soundURL = "http://140.112.90.203:4000/getSoundBySoundId/\(target)"
            
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        target = view.annotation!.title as! String
        
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
