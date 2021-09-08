//
//  SignInViewController.swift
//  MovieWorld
//
//  Created by Marimuthu T on 07/09/21.
//

import UIKit

class SignInViewController: UIViewController  {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    @IBOutlet weak var loginButton: UIButton!
    
  
    
    @IBAction func loginTapped(_ sender: UIButton) {
        
        guard emailTextField.text != nil  , passwordTextField.text != nil else
        {
            return
        }
        loginButton.isEnabled = false
        TMDBClient.loginRequest(username: emailTextField.text!, password: passwordTextField.text!, completionHandler: loginCompletionHandler(status:error:))
        
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with : event)
    }
    
    
  
    
    override func viewWillAppear(_ animated: Bool) {
        TMDBClient.getRequestToken(CompletionHandler: requestTokenCompletionHandler(status:error:))
       
      
        super.viewWillAppear(animated)
        
        emailTextField.text = "marimuthu_t"
        passwordTextField.text = "demo"
    }
    
    func loginCompletionHandler(status : Bool , error : Error? )
    {
        if status
        {
                TMDBClient.sessionId
                {
                    (status , error)  in
                    if status
                    {
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "CompleteLogin", sender: nil)
                            }
                    }
                    else
                    {
                    
                        self.errorAlertView(error: error!)
                    }
                }
            
            
        }
        else if error != nil
        {
            self.errorAlertView(error: error!)
        }
      
    }
    
    
    
    
    func requestTokenCompletionHandler(status : Bool , error : Error?)
     {
         if status
         {
             print("OKKK")
         }
         else if let error = error
         {
             errorAlertView(error: error)
         }
     }
     
     
     
     
     func errorAlertView(error : Error)
     {
         DispatchQueue.main.async {
            
            self.loginButton.isEnabled = true
             let alert = UIAlertController(title: "\(error.localizedDescription)", message: "The user credentials given are incorrect", preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
             NSLog("The \"OK\" alert occured.")
             }))
             self.present(alert, animated: true, completion: nil)
         }
     }
         
}
