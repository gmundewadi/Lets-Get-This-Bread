//
//  breadView.swift
//  letsGetThisBread
//
//  Created by gautam on 1/1/19.
//  Copyright © 2019 gautam. All rights reserved.
//

import UIKit
import AVFoundation


class breadView: UIViewController, UITextFieldDelegate{

    let dispatchGroup = DispatchGroup()
    var audioPlayer:AVAudioPlayer?
    @IBOutlet weak var v: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        v.text = ""
       
        let Tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(Tap)
        
        guard let path = Bundle.main.path(forResource: "button", ofType: "wav")
            else { return }
        
        let url = URL(fileURLWithPath: path)
        audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        v.delegate = self
       
        
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        
    }
    
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
    
    
   @objc func dismissKeyboard(){
        view.endEditing(true)
    
    }
    
    @objc func keyboardWillHide(notification: Notification){
        
        if let info = notification.userInfo {
         
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
                self.bottomConstraint.constant = 23
            }
            
        }
        
    }
    
    
    
    @objc func keyboardWillShow(notification: Notification){

        if let info = notification.userInfo {
            let rect = (info["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue

            self.view.layoutIfNeeded()

            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
                self.bottomConstraint.constant = rect.height - 90
            }

        }

    }
    
    
    @IBAction func LGTB(_ sender: Any) {
        
        
            self.performSegue(withIdentifier: "2", sender: self)
   
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
        verb = v.text!
        
        
    }
    

}
