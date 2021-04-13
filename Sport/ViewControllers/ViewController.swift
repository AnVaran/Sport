//
//  ViewController.swift
//  Sport
//
//  Created by Anton Varenik on 4/8/21.
//  Copyright © 2021 Anton Varenik. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController {

    @IBOutlet weak var coloriesGoalTextField: UITextField!
    @IBOutlet weak var eatingLabel: UILabel!
    @IBOutlet weak var burntTextField: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var breakfastView: Ingection_kcal_View!
    @IBOutlet weak var lunchView: Ingection_kcal_View!
    @IBOutlet weak var dinnerView: Ingection_kcal_View!
    @IBOutlet weak var chartKcalView: LineChartView!
    
    private var points = [ChartDataEntry]()
    
    private let chartTimeInterval = ["", "09 \n am", "12 \n am", "02 \n pm", "04 \n pm", "06 \n pm", "08 \n pm"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTopTextFields()
        setupIngectionViews()
        setupPointsToChart()
        setupDataToChartKcalView()
        setupChartKcalView()
    }
    
    private func showAlertToAddKcal(view: Ingection_kcal_View) {
        
        let alertController = UIAlertController(title: "Enter calories!", message: "Please add the number of calories you have consumed.", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter value"
            textField.keyboardType = .numberPad
        }

        let saveAction = UIAlertAction(title: "Add", style: .default, handler: { [weak self] alert -> Void in
            if let textField = alertController.textFields?[0] {
                if let text = textField.text {
                    view.ingectionKcalTextField.text = text
                    self?.setTextToEatingLabel()
                    self?.setTextToTotalLabel()
                    self?.reloadChart()
                }
            }
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {
            (action : UIAlertAction!) -> Void in })

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        alertController.preferredAction = saveAction

        self.present(alertController, animated: true, completion: nil)
    }
    
    private func setupIngectionViews() {
        let gestureBreakfast = UITapGestureRecognizer(target: self, action:
            #selector (self.someAction (_:)))
        let gestureLunch = UITapGestureRecognizer(target: self, action:
        #selector (self.someAction (_:)))
        let gestureDinner = UITapGestureRecognizer(target: self, action:
        #selector (self.someAction (_:)))
        
        self.breakfastView.addGestureRecognizer(gestureBreakfast)
        self.lunchView.addGestureRecognizer(gestureLunch)
        self.dinnerView.addGestureRecognizer(gestureDinner)
        
        breakfastView.ingectionKcalTextField.delegate = self
        lunchView.ingectionKcalTextField.delegate = self
        dinnerView.ingectionKcalTextField.delegate = self
        
        breakfastView.ingectionKcalTextField.accessibilityIdentifier = "breakfast"
        lunchView.ingectionKcalTextField.accessibilityIdentifier = "lunch"
        dinnerView.ingectionKcalTextField.accessibilityIdentifier = "dinner"
        
        breakfastView.time = Time(hour: 7, minutes: 0, second: 0)
        lunchView.time = Time(hour: 12, minutes: 0, second: 0)
        dinnerView.time = Time(hour: 17, minutes: 0, second: 0)
        
        setupShadowToView(view: breakfastView)
        setupShadowToView(view: lunchView)
        setupShadowToView(view: dinnerView)
        
        breakfastView.ingectionLabel.text = "BREAKFAST"
        lunchView.ingectionLabel.text = "LUNCH"
        dinnerView.ingectionLabel.text = "DINNER"
    }
    
    @objc func someAction(_ sender:UITapGestureRecognizer){
        breakfastView.subviews[0].layer.backgroundColor = nil
        lunchView.subviews[0].layer.backgroundColor = nil
        dinnerView.subviews[0].layer.backgroundColor = nil
        
        breakfastView.layer.shadowOpacity = 0
        lunchView.layer.shadowOpacity = 0
        dinnerView.layer.shadowOpacity = 0
        
        switch sender.view?.subviews[0].subviews[1].accessibilityIdentifier {
            case "breakfast" :
                breakfastView.subviews[0].layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                breakfastView.layer.shadowOpacity = 0.5
                setCurrentIngectionTime(view: breakfastView)
                showAlertToAddKcal(view: breakfastView)
            case "lunch" :
                lunchView.subviews[0].layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                lunchView.layer.shadowOpacity = 0.5
                setCurrentIngectionTime(view: lunchView)
                showAlertToAddKcal(view: lunchView)
            case "dinner":
                dinnerView.subviews[0].layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                dinnerView.layer.shadowOpacity = 0.5
                setCurrentIngectionTime(view: dinnerView)
                showAlertToAddKcal(view: dinnerView)
            default:
                print("default")
        }
        
    }
    private func setTextToEatingLabel() {
        let breakfastKcal = Int(breakfastView.ingectionKcalTextField.text ?? "0") ?? 0
        let dinnerKcal = Int(dinnerView.ingectionKcalTextField.text ?? "0") ?? 0
        let lunchKcal = Int(lunchView.ingectionKcalTextField.text ?? "0") ?? 0
        let eating = breakfastKcal + dinnerKcal + lunchKcal
        eatingLabel.text = "\(eating)"
    }
    
    private func reloadChart() {
        points.removeAll()
        points.append(ChartDataEntry(x: 0, y: 0))
        points.append(ChartDataEntry(x: 1, y: Double(breakfastView.ingectionKcalTextField.text ?? "0") ?? 0))
        points.append(ChartDataEntry(x: 3, y: Double(lunchView.ingectionKcalTextField.text ?? "0") ?? 0))
        points.append(ChartDataEntry(x: 5, y: Double(dinnerView.ingectionKcalTextField.text ?? "0") ?? 0))
        points.append(ChartDataEntry(x: 6, y: 0))
        
        setupDataToChartKcalView()
    }
    
    private func setupShadowToView(view: Ingection_kcal_View) {
        view.layer.shadowColor = #colorLiteral(red: 0.8039215686, green: 0.8039215686, blue: 0.8823529412, alpha: 1)
        view.layer.shadowOpacity = 0
        view.layer.shadowOffset = CGSize(width: 10, height: 20)
        view.layer.shadowRadius = 10
        view.layer.shadowPath = UIBezierPath(rect: breakfastView.bounds).cgPath
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
    }
    
    private func setupTopTextFields() {
        coloriesGoalTextField.delegate = self
        burntTextField.delegate = self
        
    }
    
    private func setupChartKcalView() {
        chartKcalView.xAxis.valueFormatter = IndexAxisValueFormatter(values:chartTimeInterval)
        chartKcalView.xAxis.drawLabelsEnabled = false
        chartKcalView.xAxis.setLabelCount(6, force: false)
        chartKcalView.xAxis.labelPosition = .bottom
        chartKcalView.xAxis.labelFont = .systemFont(ofSize: 8)
        chartKcalView.xAxis.labelTextColor = #colorLiteral(red: 0.6509803922, green: 0.6745098039, blue: 0.7450980392, alpha: 1)
        chartKcalView.xAxis.drawGridLinesEnabled = false
        chartKcalView.xAxis.axisLineColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        chartKcalView.rightAxis.enabled = false
        chartKcalView.leftAxis.enabled = false
        chartKcalView.legend.enabled = false
        chartKcalView.chartDescription?.text = ""
    }
    
    private func setupPointsToChart() {
        points.append(ChartDataEntry(x: 0, y: 0))
        points.append(ChartDataEntry(x: 7, y: 0))
    }
    
    private func setupDataToChartKcalView() {
        let line = LineChartDataSet(entries: points)
        line.colors = [#colorLiteral(red: 0.5803921569, green: 0.9607843137, blue: 0.9607843137, alpha: 1)]
        line.mode = .cubicBezier
        line.lineWidth = 2
        line.drawCircleHoleEnabled = false
        line.circleColors = [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
        line.circleRadius = 1.5
        line.valueColors = [#colorLiteral(red: 0.6509803922, green: 0.6745098039, blue: 0.7450980392, alpha: 1)]
        line.valueFont = .systemFont(ofSize: 12)
        
        line.drawVerticalHighlightIndicatorEnabled = false
        line.drawHorizontalHighlightIndicatorEnabled = false
        
        let dataFormatter = NumberFormatter()
        dataFormatter.numberStyle = .none
        dataFormatter.maximumFractionDigits = 0
        
        let data = LineChartData()
        
        data.addDataSet(line)
        data.setValueFormatter(DefaultValueFormatter(formatter: dataFormatter))
        chartKcalView.data = data
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        coloriesGoalTextField.resignFirstResponder()
        burntTextField.resignFirstResponder()
    }
}

extension ViewController {
    func createPointToChart(from view: Ingection_kcal_View) -> ChartDataEntry {
        let time = (view.time.hour * 3600) + (view.time.minutes * 60) + (view.time.second)
        let x = Double(time - 6 * 3600) * 6 / (16 * 3600)
        let y = Double(view.ingectionKcalTextField.text ?? "0") ?? 0
        
        return ChartDataEntry(x: x, y: y)
    }
    
    
    func setCurrentIngectionTime(view: Ingection_kcal_View) {
        let currentTime = GetTime.getCurrentTime()
        view.time = Time(hour: currentTime.hour, minutes: currentTime.minutes, second: currentTime.second)
        if currentTime.hour > 12 {
            view.ingectionTimeLabel.text = "\(currentTime.hour - 12):\(currentTime.minutes) pm"
        } else {
            view.ingectionTimeLabel.text = "\(currentTime.hour):\(currentTime.minutes) am"
        }
    }
}
 
extension ViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setTextToTotalLabel()
    }
    
    func setTextToTotalLabel() {
        let eating = Int(eatingLabel.text ?? "0") ?? 0
        let burn = Int(burntTextField.text ?? "0") ?? 0
        let total = eating - burn
        totalLabel.text = "\(total)"
    }
}
