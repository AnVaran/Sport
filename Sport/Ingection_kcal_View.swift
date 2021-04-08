//
//  Ingestion_kcal_View.swift
//  Sport
//
//  Created by Anton Varenik on 4/8/21.
//  Copyright © 2021 Anton Varenik. All rights reserved.
//

import UIKit

//@IBDesignable
class Ingection_kcal_View: UIView {

    @IBOutlet weak var ingectionTimeLabel: UILabel!
    @IBOutlet weak var ingectionKcalTextField: UITextField!
    @IBOutlet weak var ingectionLabel: UILabel!
    var time: Time!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    @IBAction func changintKcalValueTextField(_ sender: Any) {
        
    }
    
    private func setupView() {
        let viewFromXib = Bundle.main.loadNibNamed("Ingection_kcal_View", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        viewFromXib.layer.borderWidth = 0.5
        viewFromXib.layer.borderColor = #colorLiteral(red: 0.8117647059, green: 0.8196078431, blue: 0.8156862745, alpha: 1)
        viewFromXib.layer.cornerRadius = 13
        viewFromXib.accessibilityIdentifier = "ingectionView"
        
        addSubview(viewFromXib)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        
    }
}

struct Time {
    var hour: Int
    var minutes: Int
}
