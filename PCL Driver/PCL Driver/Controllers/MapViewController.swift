//
//  MapViewController.swift
//  PCL Driver
//
//  Created by NAMAN GARG on 6/25/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    

    @IBOutlet var customer: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var statusPicker: UIPickerView!
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var specimenCount: UILabel!
    
   
    @IBOutlet var Specimen: UITextField!
    
    var pickerData = ["Not Collected", "Collected", "Resheduled", "Missed", "Closed", "Other", "Arrived"]
    
    var custAddress = ""
    var customerName = ""
    var routeNum = 0
    var specimenNum = 0
    var driverId = 0
    var customerId = 0
    var location :LocationElement?
    var driverLocation = DriverLocation()
    var status = 0
    var geofence = false
    
    var source:CLLocationCoordinate2D?
    var destination:CLLocationCoordinate2D?
    
    var transaction = Transaction()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem?.tintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        customer.text = customerName
        address.text = custAddress
        address.tintColor = UIColor.blue
        specimenCount.text = "Number of Specimen"
        Specimen.isHidden = true
        getRoute(source!, destination!)
        self.mapView.delegate = self
        statusPicker.delegate = self
        statusPicker.dataSource = self
        
    }
    
    func getRoute(_ sourceLocation : CLLocationCoordinate2D,_ destinationLocation : CLLocationCoordinate2D) {
            let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
            let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
            
            
            let sourceMapItem = MKMapItem(placemark: sourcePlaceMark)
            let destinationItem = MKMapItem(placemark: destinationPlaceMark)
            
            
            let sourceAnotation = MKPointAnnotation()
            if let location = sourcePlaceMark.location {
                sourceAnotation.title = "Your Location"
                sourceAnotation.coordinate = location.coordinate
            }
            
            let destinationAnotation = MKPointAnnotation()
            destinationAnotation.title = customerName
            destinationAnotation.subtitle = custAddress
            if let location = destinationPlaceMark.location {
                destinationAnotation.coordinate = location.coordinate
            }
            
            self.mapView.showAnnotations([sourceAnotation, destinationAnotation], animated: true)
            
            
            
            let directionRequest = MKDirections.Request()
            directionRequest.source = sourceMapItem
            directionRequest.destination = destinationItem
            directionRequest.transportType = .automobile
            
            let direction = MKDirections(request: directionRequest)
            
            
            direction.calculate { (response, error) in
                guard let response = response else {
                    if let error = error {
                        print("ERROR FOUND : \(error.localizedDescription)")
                    }
                    return
                }
                
                let route = response.routes[0]
                self.mapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
                
                let rect = route.polyline.boundingMapRect
                
                self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
                
            }
        }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        status = row
        if row == 1 {
            Specimen.isHidden = false
        }
        else{
            Specimen.isHidden = true
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func updateLocation(){
        driverLocation.updateDriverLocation(driverId, destination!.latitude, destination!.longitude, geofence){
            [weak self] result in
            DispatchQueue.main.async {
                self?.showAlert("Driver Specimen Collection: " + result.result!)
            }
            
        }
    }
    
    @IBAction func showDirections(_ sender: UIButton) {
        let appleMapUrl = URL(string: "http://maps.apple.com/?saddr=\(source!.latitude),\(source!.longitude)&daddr=\(destination!.latitude),\(destination!.longitude)")!
        UIApplication.shared.open(appleMapUrl, options: [:], completionHandler: nil)
    }
    
    @IBAction func update(_ sender: UIButton) {
        let specimenC = Int(Specimen.text!) ?? 0
        transaction.updateTransaction(customerId, routeNum, specimenC, status, String(driverId)){ [weak self] result in
            if self?.status == 1 {
            DispatchQueue.main.async {
                if result.result == "Success"{
                    self?.updateLocation()
                    self?.navigationController?.popViewController(animated: true)
                }
                else{
                    self?.showAlert(result.result!)
                    }
                }
            }else{
                DispatchQueue.main.async {
                self?.showAlert(result.result!)
                self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func showAlert(_ result: String){
        let alert = UIAlertController(title: "Update", message: "\(result)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: {action -> Void in})
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension MapViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let rendere = MKPolylineRenderer(overlay: overlay)
        rendere.lineWidth = 5
        rendere.strokeColor = .systemBlue
        
        return rendere
    }
}
