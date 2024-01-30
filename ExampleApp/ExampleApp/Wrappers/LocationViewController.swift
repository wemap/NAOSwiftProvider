//
//  LocationViewController.swift
//  ExampleApp
//
//  Created by polestar on 05/09/2023.
//
import Foundation
import SwiftUI
import UIKit
import NAOSwiftProvider
import CoreLocation

class LocationViewController: UIViewController, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager!

    var locHandle: LocationProvider?
    var geoHandle: GeofencingHandler?
    let tableView = UITableView()
    let quitButton = UIButton()
    var locationData = [String]() // Location data array
    
    let apiKey: String = "OuZ9N5CqUISbUGIzalXxRg"
//    let apiKey: String = "96evcK44OGGUJxcIAGn2jg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupUI()
        
        // Register for the UIApplicationWillEnterForeground and UIApplicationDidEnterBackground notifications
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        
        DispatchQueue.main.async {
            self.locHandle = LocationProvider(apikey: self.apiKey)
            self.locHandle?.delegate = self
            self.locHandle?.synchronizeData()
            
            self.geoHandle = GeofencingHandler(apikey: self.apiKey)
            self.geoHandle?.delegate = self
            self.geoHandle?.synchronizeData()
            
            self.locHandle?.start()
            self.geoHandle?.start()
        }
            
    }

    @objc private func onQuitButtonPressed(){
        self.geoHandle?.stop()
        self.locHandle?.stop()
        // Dismiss the presented view controller
        self.dismiss(animated: true, completion: nil)
    }

    private func setupUI(){
        // Create and configure the table view
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(self.tableView)

        // Create and configure the button
        self.quitButton.translatesAutoresizingMaskIntoConstraints = false
        self.quitButton.setTitle("QUIT", for: .normal)
        self.quitButton.setTitleColor(UIColor.white, for: .normal)
        self.quitButton.backgroundColor = UIColor.systemBlue
        self.quitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        // Calculate the desired width based on a percentage of the view's width
        let widthPercentage: CGFloat = 0.8 // 80% of the view's width
        let constant = view.bounds.width * widthPercentage

        // Set the width constraint constant
        self.quitButton.widthAnchor.constraint(equalToConstant: constant).isActive = true
        self.quitButton.layer.cornerRadius = 8
        self.quitButton.addTarget(self, action: #selector(onQuitButtonPressed), for: .touchUpInside)
        view.addSubview(self.quitButton)
        
        // Pin the top of the table view to the top of the view
        self.tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true

        // Pin the leading edge of the table view to the leading edge of the view
        self.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true

        // Pin the trailing edge of the table view to the trailing edge of the view
        self.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        // Pin the bottom of the table view to the top of the button
        self.tableView.bottomAnchor.constraint(equalTo: self.quitButton.topAnchor).isActive = true

        // Pin the leading edge of the button to the leading edge of the view
        self.quitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true

        // Pin the trailing edge of the button to the trailing edge of the view
        self.quitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        // Pin the bottom of the button to the bottom of the view
        self.quitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    @objc func appWillEnterForeground() {
        let authorizationStatus: CLAuthorizationStatus
        let manager = CLLocationManager()
        // Perform any actions you want when the app is about to enter the foreground
        print("1. ################ Application will enter foreground")
        
        self.locHandle?.setPowerMode(power: .HIGH)
        self.geoHandle?.setPowerMode(power: .HIGH)
        
        if #available(iOS 14, *) {
            authorizationStatus = manager.authorizationStatus
        }
        else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        if authorizationStatus != .authorizedAlways {
            // L'autorisation "Always" a été accordée
            print("CASE 1. START   ################ Enters in foreground without ALWAYS authorization!")
            self.locHandle?.start()
            self.geoHandle?.start()
        }
    }

    @objc func appDidEnterBackground() {
        let authorizationStatus: CLAuthorizationStatus
        let manager = CLLocationManager()
        
        // Perform any actions you want when the app enters the background
        print("2. ################ Application did enter background")
        self.locHandle?.setPowerMode(power: .LOW)
        self.geoHandle?.setPowerMode(power: .LOW)
        
        if #available(iOS 14, *) {
            authorizationStatus = manager.authorizationStatus
        }
        else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        if authorizationStatus != .authorizedAlways {
            // L'autorisation "Always" a été accordée
            print("CASE 2. STOP   ################ Enters in background without ALWAYS authorization!")
            self.locHandle?.stop()
            self.geoHandle?.stop()
        }
    }

    deinit {
        self.locHandle?.stop()
        self.geoHandle?.stop()
        // Unregister the observers when the view controller is deallocated
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
}

extension LocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locationData.count // Replace with your actual data count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row). \(self.locationData[indexPath.row])"
        return cell
    }
}

extension LocationViewController: GeofencingHandlerDelegate {
    func didEnterGeofence(_ regionId: Int32, andName regionName: String!) {
        print("Did geofence enter into the \(regionName ?? "")")
    }
    
    func didExitGeofence(_ regionId: Int32, andName regionName: String!) {
        print("Did geofence exit the \(regionName ?? "")")
    }
    
    func didFire(_ message: String!) {
        
    }
    
    func didGeofencingFailWithErrorCode(_ message: String!) {
        
    }
}

extension LocationViewController: LocationProviderDelegate {
    
    func didLocationChange(_ location: CLLocation!){
        let latitude = (location.coordinate.latitude.description as NSString).doubleValue
        let longitude = (location.coordinate.longitude.description as NSString).doubleValue
        let floor = ((location!.altitude as Double)/5) as NSNumber
        let newLocationItem = "(\(longitude), \(latitude), \(location!.altitude))"
        print(newLocationItem)
        self.locationData.append(newLocationItem)
        tableView.reloadData()
    }
    
    func didLocationStatusChanged(_ status: String!){
//        let notification = NotificationMessageRow(image: Icons.info!, message: status, type: .info)
//        NotificationViewController.update(notification: notification)
    }
    
    func didEnterSite (_ name: String!){
//        let notification = NotificationMessageRow(image: Icons.enter!, message: "Enter into the \(name ?? "")", type: .location)
//        NotificationViewController.update(notification: notification)
//        print("Enter into the \(name ?? "")")
    }
    
    func didExitSite (_ name: String!){
//        let notification = NotificationMessageRow(image: Icons.exit!, message: "Exit the \(name ?? "")", type: .location)
//        NotificationViewController.update(notification: notification)
    }
    
    func didLocationFailWithErrorCode(_ message: String!){
//        let notification = NotificationMessageRow(image: Icons.error!, message: message, type: .error)
//        NotificationViewController.update(notification: notification)
    }
    
    func didApikeyReceived (_ apikey: String!){
    }
    
    // MARK: - NAOSyncDelegate --

    func didSynchronizationSuccess(){

    }

    func didSynchronizationFailure(_ message: String!){

    }
    
    func presentAlertDialog(title: String, message: String) -> Void{
        /* Create a UIAlertController object with provided title, message and alert dialog style. */
        let alertController:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
     
        /* Create a UIAlertAction object with title to implement the alert dialog OK button. */
        let alertAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:nil)
        /* Add above UIAlertAction button to the UIAlertController object. */
        alertController.addAction(alertAction)
        
        /* Display the swift alert dialog window. */
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - NAOSensorsDelegate
    
    func requiresWifiOn(){

    }

    func requiresBLEOn(){

    }

    func requiresLocationOn(){

    }

    func requiresCompassCalibration(){

    }
}


struct LocationViewControllerWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = LocationViewController

    func makeUIViewController(context: Context) -> LocationViewController {
        return LocationViewController()
    }

    func updateUIViewController(_ uiViewController: LocationViewController, context: Context) {
        // You can update your view controller here if needed
    }
}
