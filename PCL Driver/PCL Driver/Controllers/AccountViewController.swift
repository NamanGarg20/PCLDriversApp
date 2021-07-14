//
//  AccountViewController.swift
//  PCL Driver
//
//  Created by NAMAN GARG on 6/25/21.
//

import UIKit

class AccountViewController: UIViewController {
    
    let login = DriverLogin()

    @IBOutlet var number: UITextField!
    @IBOutlet var newPassword: UITextField!
    @IBOutlet var confirmPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white

        // Do any additional setup after loading the view.
    }

    @IBAction func SignUp(_ sender: UIButton) {
        let driverNum = number.text!
        let newPass = newPassword.text!
        let confirm = confirmPassword.text!
        
        login.createAccount(driverNum, newPass, confirm) { [weak self] result in
            DispatchQueue.main.async {
                self?.signUPUser(result)
            }
            
        }
    }
    
    func signUPUser(_ completion: Completion){
        if let comp = completion.result{
            if comp == "success"{
                let alert = UIAlertController(title: "User", message: "\(comp)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: {action -> Void in
                    self.navigationController?.popViewController(animated: true)
                })
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "User", message: "\(comp)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: {action -> Void in
                })
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
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
