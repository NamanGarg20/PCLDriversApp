//
//  RoutesTableViewController.swift
//  PCL Driver
//
//  Created by NAMAN GARG on 6/25/21.
//

import UIKit
import CoreLocation

class RoutesTableViewController: UITableViewController, CLLocationManagerDelegate {
    var routes = Routes()
    var customers = [Customer]()
    var routeDetail :Route?
    var routeArr = [RouteDetailElement]()
    var driverId : Int?
    var driverLoc = DriverLocation()
    var location :LocationElement?
    var timer : Timer?
    
    var geofence = false
    
    var user = CLLocationCoordinate2D()
    var source = CLLocationCoordinate2D()
    var destination = CLLocationCoordinate2D()
    
    var locationManager = CLLocationManager()
    var geoFenceRegion : CLCircularRegion?
    
    var count = 0
    
    var address = ""
    var customerName = ""
    var specimenCount = 0
    var routeNum = 0
    var customerId = 0
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
        })
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
                locationManager.startUpdatingLocation()
            }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
    }
    
    func showRouteInfo() {
        
        for route in customers {
            startGeoFence(coordinates: CLLocationCoordinate2D(latitude: (route.custLat)!, longitude: (route.custLog)!), custId : "\(route.customerID ?? 0)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        routes.getRoute(routeNum){ [weak self] (result) in
            self?.routeArr = result
            self?.routeDetail = result.first?.route
            self?.driverId = (result.first?.route?.driverID!)!
            self?.customers = (result.first?.customer!)!
            DispatchQueue.main.async {
                self?.showRouteInfo()
                self?.tableView.reloadData()
            }
        }
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
        })
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
                locationManager.startUpdatingLocation()
            }
    }
    
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        guard let scene = self.view.window?.windowScene?.delegate as? SceneDelegate else {
            return
        }
        
        scene.openLoginView()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return customers.count + 1
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let routeCell = tableView.dequeueReusableCell(withIdentifier: "DriverInfoCell") as! DetailTableViewCell
            if let detail = routeDetail{
            routeCell.RouteName.text = "Route Name: \(detail.routeName!)"
            routeCell.Vehicle.text = "Vehicle : \(detail.vehicleNo!)"
            routeCell.RouteNumber.text = "Route Number : \(detail.routeNo!)"
            routeNum = detail.routeNo!
            routeCell.customers.text = "Number of Customers: \(customers.count)"
            
            }
            return routeCell
        }
        let  customerCell = tableView.dequeueReusableCell(withIdentifier: "DriverCell", for: indexPath) as! RouteTableViewCell
        if customers.count>0{
            
            customerCell.customerName.text = customers[indexPath.row-1].customerName!

            let customerAddress: String =  "\(customers[indexPath.row-1].streetAddress!), \(customers[indexPath.row-1].city!), \(customers[indexPath.row-1].state!), \(customers[indexPath.row-1].zip!)"
            customerCell.address.text = customerAddress
            customerCell.address.tintColor = UIColor.blue

            customerCell.date.text = "\(customers[indexPath.row-1].pickUpTime!)"
            if let status = customers[indexPath.row-1].collectionStatus{
            
                if status == "Collected"{
                    customerCell.isselected.isHidden = false
                    customerCell.isselected.text = " ✅ \(status)"
                    customerCell.isselected.textColor = UIColor.green
                    customerCell.distance.text = "Specimen Collected: \(customers[indexPath.row-1].specimensCollected!)"
                }else{
                    if status == "NotCollected" {
                        customerCell.isselected.text = "🚫 Not Collected"
                    }else{
                        customerCell.isselected.text = "🚫 \(status)"
                    }
                    customerCell.isselected.textColor = UIColor.red
                    
                let distance = calculateDistance(customers[indexPath.row-1].custLat! , customers[indexPath.row-1].custLog!)
                
                customerCell.distance.text = "\(distance) Miles"
                }
            }
            customerCell.id.text = "\(customers[indexPath.row-1].customerID!)"
        }

            return customerCell
        

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            tableView.deselectRow(at: indexPath, animated: true)
        }else{
        if let _ = customers[indexPath.row-1].collectionStatus {
//            if status != "Collected"{
                customerName = customers[indexPath.row-1].customerName!
                address =  "\(customers[indexPath.row-1].streetAddress!), \(customers[indexPath.row-1].city!), \(customers[indexPath.row-1].state!), \(customers[indexPath.row-1].zip!)"
                specimenCount = customers[indexPath.row-1].specimensCollected!
                customerId = customers[indexPath.row-1].customerID!
                destination = CLLocationCoordinate2D(latitude: customers[indexPath.row-1].custLat!, longitude: customers[indexPath.row-1].custLog!)
                performSegue(withIdentifier: "showRoute", sender: self)
//                }
//                else{
//                    tableView.deselectRow(at: indexPath, animated: true)
//                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRoute"{
            let mapVC = segue.destination as! MapViewController
            mapVC.custAddress = address
            mapVC.customerName = customerName
            mapVC.customerId = customerId
            mapVC.specimenNum = specimenCount
            mapVC.routeNum = routeNum
            mapVC.driverId = driverId!
            mapVC.source = source
            mapVC.destination = destination
            mapVC.geofence = geofence
            
            mapVC.navigationController?.navigationBar.barTintColor = UIColor.white
            
        }
    }
    
    func calculateDistance(_ DestinationX:Double,_ DestinationY:Double) -> Double {
        let X = source.latitude
        let Y = source.longitude
            
            let coordinate0 = CLLocation(latitude: X, longitude: Y)
            let coordinate1 = CLLocation(latitude: DestinationX, longitude:  DestinationY)
            let distanceInMeters = coordinate0.distance(from: coordinate1)
            let distance = distanceInMeters * 0.000621371
            return round(distance*100)/100.00
                
        }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations.last!

        manager.stopUpdatingLocation()

        let coordinations = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)

        source = coordinations
        runTimer()
        self.tableView.reloadData()
    }
    
    func runTimer(){
        self.timer = Timer(fire: Date(), interval: 10.0, repeats: true, block: { (Timer) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        RunLoop.current.add(self.timer!, forMode: .default)
        self.tableView.reloadData()
    }
    
    func startGeoFence(coordinates: CLLocationCoordinate2D, custId : String){
        geoFenceRegion = CLCircularRegion(center: coordinates, radius: 100, identifier: custId)
        geoFenceRegion!.notifyOnEntry = true
        geoFenceRegion!.notifyOnExit = true
        locationManager.startMonitoring(for: geoFenceRegion!)
    }
    
    func showNotifications(_ title: String, _ body: String){
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest.init(identifier: "alert", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        let regions = customers.filter {customer in
            String(customer.customerID!) == region.identifier
        }
        if regions.count>0{
            let title = "You have reached \(regions.first?.customerName ?? "None")"
            let body = "Please update specimens when collected."
            showNotifications(title, body)
            geofence = true
            self.tableView.reloadData()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let regions = customers.filter {customer in
            String(customer.customerID!) == region.identifier
        }
        if regions.count>0{
            let title = "Yoy have exited \(regions.first?.customerName ?? "None")"
            let body = "Did you update collected specimens?"
            showNotifications(title, body)
            geofence = false
            self.tableView.reloadData()
            locationManager.stopMonitoring(for: geoFenceRegion!)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
