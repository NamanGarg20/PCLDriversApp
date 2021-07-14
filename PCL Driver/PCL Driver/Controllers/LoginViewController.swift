//
//  LoginViewController.swift
//  PCL Driver
//
//  Created by NAMAN GARG on 6/25/21.
//

import UIKit
import LocalAuthentication
import Security

class LoginViewController: UIViewController {
    
    let login = DriverLogin()
    
    var number = ""
    var driverPass = ""
    var bioSwitch = false
    
    @IBOutlet var DriverNumber: UITextField!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var password: UITextField!
    
    var biometric = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let biometricCase = UserDefaults.standard.value(forKey: "key") as? Bool{
            bioSwitch = biometricCase
        }
        
        if bioSwitch == true {
            if let bioNum = UserDefaults.standard.value(forKey: "userBioKey") as? String{
                number = bioNum
            }
            if let bioPass = UserDefaults.standard.value(forKey: "userBioPass") as? String{
                driverPass = bioPass
            }
            biometric = true
            biometrics()
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Login(_ sender: UIButton) {
        loginDriver()
    }
    
    
    func biometrics(){
        let context = LAContext()
        context.localizedFallbackTitle = "Use Password"
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "Identify Yourself"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason){
                success, authenticationError in
                DispatchQueue.main.async {
                    if success{
                        self.Login(self.loginBtn)
                    }else{
                        self.showLoginAlert("You could not be verified")
                        guard authenticationError != nil else { return }
                    }
                }
            }
        }else{
            self.showLoginAlert("Biometrics not configured")
            guard error != nil else { return }
        }
    }
    
    
    func loginDriver(){
        if biometric == false{
            number = DriverNumber.text!
            driverPass = password.text!
        }
        
        login.login(number, driverPass){ [weak self] (result) in
            DispatchQueue.main.async {
                UserDefaults.standard.set(self?.DriverNumber.text!, forKey: "userBioKey")
                UserDefaults.standard.set(self?.password.text!, forKey: "userBioPass")
                UserDefaults.standard.synchronize()
                self?.showRoutes(result)
            }
        }
        
    }
    
    func showRoutes(_ result: DriverRoute){
        if let routeNum = result.routeNo{
            guard let routeVC = self.view.window?.windowScene?.delegate as? SceneDelegate else {
                return
            }
            routeVC.showDriverView(routeNum)
        }
        
        else if let res = result.result{
            showLoginAlert(res)
        }
        else{
            showLoginAlert("Unable to Login")
        }
    }
    
    func showLoginAlert(_ res: String){
        let alert = UIAlertController(title: "Alert", message: res, preferredStyle: .alert)
        
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
