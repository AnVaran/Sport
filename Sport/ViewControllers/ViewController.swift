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
    @IBOutlet weak var eatingTextField: UITextField!
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
        
        setupTopFields()
        setupIngectionViews()
        setupPointsToChart()
        setupDataToChartKcalView()
        setupChartKcalView()
    }
    
    private func setupIngectionViews() {
        breakfastView.ingectionKcalTextField.delegate = self
        lunchView.ingectionKcalTextField.delegate = self
        dinnerView.ingectionKcalTextField.delegate = self
        
        breakfastView.ingectionKcalTextField.accessibilityIdentifier = "breakfast"
        lunchView.ingectionKcalTextField.accessibilityIdentifier = "lunch"
        dinnerView.ingectionKcalTextField.accessibilityIdentifier = "dinner"
        
        breakfastView.time = Time(hour: 7, minutes: 0)
        lunchView.time = Time(hour: 12, minutes: 0)
        dinnerView.time = Time(hour: 17, minutes: 0)
        
        breakfastView.ingectionLabel.text = "BREAKFAST"
        lunchView.ingectionLabel.text = "LUNCH"
        dinnerView.ingectionLabel.text = "DINNER"
    }
    
    private func setupTopFields() {
        coloriesGoalTextField.delegate = self
        eatingTextField.delegate = self
        burntTextField.delegate = self
    }
    
    private func setupChartKcalView() {
        chartKcalView.xAxis.valueFormatter = IndexAxisValueFormatter(values:chartTimeInterval)
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
        
        if textField.superview?.superview?.accessibilityIdentifier == "ingectionView" {
            points.removeAll()
            points.append(ChartDataEntry(x: 0, y: 0))
            points.append(createPointToChart(from: breakfastView))
            points.append(createPointToChart(from: lunchView))
            points.append(createPointToChart(from: dinnerView))
            points.append(ChartDataEntry(x: 6, y: 0))
            
            setupDataToChartKcalView()
            
        }
    }
    
    func createPointToChart(from view: Ingection_kcal_View) -> ChartDataEntry {
        let time = view.time.hour
        let x = Double(time - 6) * 6 / 16
        let y = Double(view.ingectionKcalTextField.text ?? "0") ?? 0
        
        return ChartDataEntry(x: x, y: y)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        if textField.superview?.superview?.accessibilityIdentifier == "ingectionView" {
            
            breakfastView.subviews[0].layer.backgroundColor = nil
            lunchView.subviews[0].layer.backgroundColor = nil
            dinnerView.subviews[0].layer.backgroundColor = nil
            
            switch textField.accessibilityIdentifier {
            case "breakfast" :
                breakfastView.subviews[0].layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                setCurrentIngectionTime(view: breakfastView)
            case "lunch" :
                lunchView.subviews[0].layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                setCurrentIngectionTime(view: lunchView)
            case "dinner":
                dinnerView.subviews[0].layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                setCurrentIngectionTime(view: dinnerView)
            default:
                print("default")
            }
        }
        
        return true
    }
    
    func setCurrentIngectionTime(view: Ingection_kcal_View) {
        let currentTime = GetTime.getCurrentTime()
        //view.time = Time(hour: currentTime.hour, minutes: currentTime.minutes)
        if currentTime.hour > 12 {
            view.ingectionTimeLabel.text = "\(currentTime.hour - 12):\(currentTime.minutes) pm"
        } else {
            view.ingectionTimeLabel.text = "\(currentTime.hour):\(currentTime.minutes) am"
        }
    }
}
