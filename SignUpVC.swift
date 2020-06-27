//
//  SignUpVC.swift
//  Poke
//
//  Created by Kaiwen Shen on 1/30/20.
//  Copyright © 2020 Kaiwen Shen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SwiftKeychainWrapper


class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userImagePick: UIImageView!
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    var userUid: String!
    
    var emailField: String!
    
    var passwordField: String!
    
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.delegate=self
        
        imagePicker.allowsEditing = true
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: "uid") {
            performSegue(withIdentifier: "toMessages", sender: nil)
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            userImagePick.image = image
            imageSelected = true
        } else {
            print("Image wasn't selected")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func setUser(img: String) {
        let userData = [
            "username": username!,
            "userImg": img
        ]
        
        KeychainWrapper.standard.set(userUid, forKey: "uid")
        
        let location = Database.database().reference().child("users").child(userUid)
        
        location.setValue(userData)
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func uploadImg() {
        if usernameField.text == nil {
            signUpBtn.isEnabled = false
        } else {
            username = usernameField.text
            
            signUpBtn.isEnabled = true
        }
        
        guard let img = userImagePick.image, imageSelected == true else {
            print("image needs to be selected")
            
            return
        }
        
        if let imgData = img.jpegData(compressionQuality: 0.2){
            let imgUid = NSUUID().uuidString
            let metadata = StorageMetadata()
            
            metadata.contentType = "image/jepg"
            
            let uploadRef = Storage.storage().reference().child(imgUid)
            _ = uploadRef.putData(imgData, metadata: metadata) {
                (metadata, error) in
                if error != nil {
                    print("Did not upload image")
                } else {
                    print("Uploaded")
                    uploadRef.downloadURL{
                        (url, error) in
                        if let downloadURL = url?.absoluteString {
                            self.setUser(img: downloadURL)
                        }
                    }
                }
            }
            
        }
    }
    
    @IBAction func createAccount(_ sender: AnyObject) {
        Auth.auth().createUser(withEmail: emailField, password: passwordField, completion: {
            (user, error) in
            if error != nil {
                print("Can't create user")
                let myAlert = UIAlertController(title: "loginAlert", message: "Can't create user", preferredStyle: .alert)
                
                let dismissAlert = UIAlertAction(title: "Cancel", style: .cancel)
                myAlert.addAction(dismissAlert)
                self.present(myAlert, animated: true, completion: nil)
                
            } else {
                if let user = user {
                    self.userUid = user.user.uid
                }
            }
            self.uploadImg()
            
        })
        
    }
    
    @IBAction func selectedImgPicker (_ sender: AnyObject) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancel (_sender: AnyObject) {
        dismiss(animated: true, completion: nil)
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
