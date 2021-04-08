//
//  ViewController.swift
//  Sport
//
//  Created by Anton Varenik on 4/8/21.
//  Copyright © 2021 Anton Varenik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var coloriesGoalTextField: UITextField!
    @IBOutlet weak var eatingTextField: UITextField!
    @IBOutlet weak var burntTextField: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var breakfastView: Ingection_kcal_View!
    @IBOutlet weak var lunchView: Ingection_kcal_View!
    @IBOutlet weak var dinnerView: Ingection_kcal_View!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coloriesGoalTextField.delegate = self
        eatingTextField.delegate = self
        burntTextField.delegate = self
        
        breakfastView.ingectionKcalTextField.delegate = self
        lunchView.ingectionKcalTextField.delegate = self
        dinnerView.ingectionKcalTextField.delegate = self
        
        breakfastView.ingectionKcalTextField.accessibilityIdentifier = "breakfast"
        lunchView.ingectionKcalTextField.accessibilityIdentifier = "lunch"
        dinnerView.ingectionKcalTextField.accessibilityIdentifier = "dinner"
        
        
        breakfastView.ingectionLabel.text = "BREAKFAST"
        lunchView.ingectionLabel.text = "LUNCH"
        dinnerView.ingectionLabel.text = "DINNER"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        breakfastView.ingectionKcalTextField.resignFirstResponder()
        lunchView.ingectionKcalTextField.resignFirstResponder()
        dinnerView.ingectionKcalTextField.resignFirstResponder()
        
        coloriesGoalTextField.resignFirstResponder()
        eatingTextField.resignFirstResponder()
        burntTextField.resignFirstResponder()
    }
}
 
extension ViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let color = Int(coloriesGoalTextField.text ?? "0") ?? 0
        let eating = Int(eatingTextField.text ?? "0") ?? 0
        let burn = Int(burntTextField.text ?? "0") ?? 0
        let total = color + eating - burn
        totalLabel.text = "\(total)"
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        if textField.superview?.superview?.accessibilityIdentifier == "ingectionView" {
            
            breakfastView.subviews[0].layer.backgroundColor = nil
            lunchView.subviews[0].layer.backgroundColor = nil
            dinnerView.subviews[0].layer.backgroundColor = nil
            
            switch textField.accessibilityIdentifier {
            case "breakfast" :
                breakfastView.subviews[0].layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            case "lunch" :
                lunchView.subviews[0].layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            case "dinner":
                dinnerView.subviews[0].layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            default:
                print("default")
            }
        }
        
        return true
    }
}
