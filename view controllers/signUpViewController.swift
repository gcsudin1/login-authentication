//
//  signUpViewController.swift
//  login authentication
//
//  Created by IMCS2 on 9/1/19.
//  Copyright © 2019 IMCS2. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class signUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var EmailtextField: UITextField!
    
    @IBOutlet weak var PasswordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
setUpElements()
        // Do any additional setup after loading the view.
    }
    func setUpElements(){
        errorLabel.alpha = 0 // hiding error label
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(EmailtextField)
        Utilities.styleTextField(PasswordTextField)
        Utilities.styleFilledButton(signUpButton)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func validateFields() -> String? {
        // check all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            EmailtextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || PasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" 
            {
            return "Please fill in all fields."
        }
        //check if the password is secure
        let cleanedPassword = PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanedPassword) == false {
            
            return "Please make sure your password is at least 8 characters, contains a special charater and a number."
            
        }
        
        return nil
    }
    @IBAction func signUpTapped(_ sender: Any) {
        //validate the fields
        let error = validateFields()
        if error != nil {
            showError(error!)
        }
        else {
            //create cleaned versions of data
            
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let Email = EmailtextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            //create the user
            Auth.auth().createUser(withEmail:Email, password: password) { (result, err) in
                //check for errors
                if  err != nil {
                    //there was an error creating the user
                    self.showError("Error creating the user")
            }
                else{
                    //user was created successfully, now store the first and last name
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["firstname":firstName,"lastName":lastName,"uid":result!.user.uid]){ (error) in
                        
                        if error != nil {
                            self.showError("Error saving user data")
                        }
                    }
                    // transition to home screen
                    self.transitionToHome()
                }
            }
        }
            
        
        
        // create the user
        
        
        //transition to home screen
    }
        func showError(_ message:String) {
            errorLabel.text = message
            errorLabel.alpha = 1
        }
    func transitionToHome (){
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: Constatnts.Storyboard.homeViewController) as? HomeViewController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
    

}
