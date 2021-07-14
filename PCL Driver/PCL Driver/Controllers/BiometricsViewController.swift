//
//  BiometricsViewController.swift
//  PCL Driver
//
//  Created by NAMAN GARG on 6/25/21.
//

import UIKit

class BiometricsViewController: UIViewController {

    var biometric = false
    @IBOutlet var BiometricsSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        change.isHidden = true
        
        if let switchCase = UserDefaults.standard.value(forKey: "key") as? Bool{
            biometric = switchCase
        }
        
        if biometric == true {
            BiometricsSwitch.isOn = true
        }else{
            BiometricsSwitch.isOn = false
        }
        
    }
    
    @IBAction func Activate_switch(_ sender: UISwitch) {
        activateBiometrics()
    }
    func activateBiometrics(){
        if BiometricsSwitch.isOn {
            UserDefaults.standard.set(true, forKey: "key")
        }
        else{
            UserDefaults.standard.set(false, forKey: "key")
        }
        
        UserDefaults.standard.synchronize()
    }
    
    @IBOutlet var change: UIStackView!
    
  
    @IBAction func changePassword(_ sender: UIButton) {
        change.isHidden = false
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
