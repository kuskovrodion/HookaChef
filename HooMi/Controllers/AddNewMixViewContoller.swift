//
//  AddNewMixViewContoller.swift
//  HooMi
//
//  Created by Родион on 15.01.2018.
//  Copyright © 2018 Rodion Kuskov. All rights reserved.
// Give a name to your masterpiece
//

import UIKit
import Firebase
class AddNewMixViewContoller: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    enum Bowls : String {
        case eg = "Egyptian"
        case ph = "Phunnel"
        case vo = "Vortex"
    }
    
    @IBAction func takingImageBarButtom(_ sender: UIBarButtonItem) {
        takePhotoToAddingMix()
    }
    
    @IBAction func handleClicking(_ sender: UIButton) {
        hideAndAppear()
    }
    
    @IBOutlet var bowlButton: [UIButton]!
    @IBAction func bowlTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle, let bowl = Bowls(rawValue: title) else {
            return
        }
        switch bowl {
        case .eg:
            bowlNameButton.setTitle("Egyptian", for: .normal)
            hideAndAppear()
        case .ph:
            bowlNameButton.setTitle("Phunnel", for: .normal)
            hideAndAppear()
        case .vo:
            bowlNameButton.setTitle("Vortex", for: .normal)
            hideAndAppear()
        }
    }
    
    @IBOutlet weak var bowlNameButton: UIButton!
    
    
    
    func hideAndAppear() {
        bowlButton.forEach { (button) in
            UIView.animate(withDuration: 0.2, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    

    

    
    
    @IBAction func shareMixButton(_ sender: UIButton) {
        if takenImage == nil {
            let ErrorAlert = UIAlertController(title: "Oops..", message: "Choose image", preferredStyle: .alert)
            
            let ErrorAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            ErrorAlert.addAction(ErrorAction)
            
            self.present(ErrorAlert, animated: true, completion: nil)
        }
        
        if AddNewMixName.text != "" && AddNewMixDescription.text != "" {
            
            let mix = Mix(image: takenImage, MixName: AddNewMixName.text!, MixDesc: AddNewMixDescription.text, mixBowl: (bowlNameButton.titleLabel?.text)!, mixStrength: mixStrengthLabel.text!)
            mix.saveIntoDatabase()
            self.dismiss(animated: true, completion: nil)
            
            let alert = UIAlertController(title: "Congrats!", message: "Your mix was successfully saved", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Cool!", style: .default) { (action) -> Void in
                let present = self.storyboard?.instantiateInitialViewController()

                self.present(present!, animated: true, completion: nil)
            }
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
            
            
        } else {
            
            let ErrorAlert = UIAlertController(title: "Oops..", message: "Values cant be blank", preferredStyle: .alert)
            
            let ErrorAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            ErrorAlert.addAction(ErrorAction)
            
            self.present(ErrorAlert, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var AddNewMixName: UITextField!
    @IBOutlet weak var AddNewMixDescription: UITextView!
    
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 80
    }
     func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= 150
    }
    

    
    var imagePicker: UIImagePickerController!
    var takenImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func takePhotoToAddingMix() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.cameraCaptureMode = .photo
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var test = 0
    var deleteClicks = 0
    
    @IBOutlet weak var tabackNameFirstField: UITextField!
    @IBOutlet weak var tabackNameSecondField: UITextField!
    @IBOutlet weak var tabackNameThirdField: UITextField!
    @IBOutlet weak var tabackNameForthField: UITextField!
    
    @IBOutlet weak var tabackPercentsFirstField: UITextField!
    @IBOutlet weak var tabackPercentsSecondField: UITextField!
    @IBOutlet weak var tabackPercentsThirdField: UITextField!
    @IBOutlet weak var tabackPercentsForthField: UITextField!
    
    @IBAction func addRowButton(_ sender: UIButton) {
            test += 1
            print("ПЛЮСИК \(test)")
            if test == 1 {
                tabackNameSecondField.isHidden = false
                tabackPercentsSecondField.isHidden = false
                outletDeleteRowButton.isHidden = false
            } else if test == 2 {
                tabackNameThirdField.isHidden = false
                tabackPercentsThirdField.isHidden = false
                outletDeleteRowButton.isHidden = false
            } else if test == 3 {
                tabackNameForthField.isHidden = false
                tabackPercentsForthField.isHidden = false
                outletDeleteRowButton.isHidden = false
                test = 0
            }
    }
    
    @IBOutlet weak var outletDeleteRowButton: UIButton!
    @IBAction func deleteRowButton(_ sender: UIButton) {
        
        deleteClicks += 1
        print("МИНУСИК \(deleteClicks)")
        if deleteClicks == 1 {
            tabackNameSecondField.isHidden = true
            tabackPercentsSecondField.isHidden = true
        } else if deleteClicks == 2 {
            tabackNameThirdField.isHidden = true
            tabackPercentsThirdField.isHidden = true
        } else if deleteClicks == 3 {
            tabackNameForthField.isHidden = true
            tabackPercentsForthField.isHidden = true
            outletDeleteRowButton.isHidden = true
            deleteClicks = 0
        }

    }
    
    @IBOutlet weak var mixStrengthLabel: UILabel!
    @IBAction func mixStrengthSlider(_ sender: UISlider) {
        mixStrengthLabel.text = String(Int(sender.value))
    }
    
    
}

extension AddNewMixViewContoller : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.takenImage = image
        backgroundImageView.image = self.takenImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}










