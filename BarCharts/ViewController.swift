//
//  ViewController.swift
//  BarCharts
//
//  Created by Rostyslav Hetmaniuk on 11/20/17.
//  Copyright © 2017 Rostyslav Hetmaniuk. All rights reserved.
//

import UIKit
import Charts
import Foundation

class ViewController: UIViewController, ChartViewDelegate {
    @IBOutlet weak var chartView: BarChartView!
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var dotsChart: ScatterChartView!
    
    fileprivate var dataChart: DataChart!
    fileprivate var requestTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRequest()
        chartView.delegate = self
        chartView.noDataText = "You need to provide data for the chart."
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.granularity = 1
        
        dotsChart.isHidden = true
        dotsChart.delegate = self
        dotsChart.noDataText = "You need to provide data for the chart."
        dotsChart.xAxis.drawAxisLineEnabled = false
        dotsChart.xAxis.drawGridLinesEnabled = false
        dotsChart.xAxis.labelPosition = .bottom
        dotsChart.xAxis.granularity = 1
        
        requestTimer = Timer.scheduledTimer(timeInterval: 300.0, target: self, selector: #selector(getRequest), userInfo: nil, repeats: true)
    }
    
    @IBAction func onSegmentChanged(_ sender: Any)
    {
        raisePropertyChanged()
    }
    
    fileprivate func setDotsChart()
    {
        let m15Set = getDataSet(val: dataChart.m15, label: "M15", color: NSUIColor.blue)
        let h1Set = getDataSet(val: dataChart.h1, label: "H1", color: NSUIColor.red)
        let h4Set = getDataSet(val: dataChart.h4, label: "H4", color: NSUIColor.green)
        let d1Set = getDataSet(val: dataChart.d1, label: "D1", color: NSUIColor.purple)
        let data = ScatterChartData(dataSets: [m15Set, h1Set, h4Set, d1Set])
        data.setValueFont(.systemFont(ofSize: 7, weight: .light))
        dotsChart.data = data
        dotsChart.animate(xAxisDuration: 2)
    }
    
    fileprivate func setBarChart(values:[Pair])
    {
        var dataSets: [BarChartDataSet] = []
        for i in 0..<values.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i].value)
            let dataSet = BarChartDataSet(values: [dataEntry], label: nil)
            dataSet.setColor(NSUIColor.blue)
            dataSets.append(dataSet)
        }
        let chartData = BarChartData(dataSets: dataSets)
        chartData.barWidth = 0.9
        chartView.data = chartData
        chartView.animate(yAxisDuration: 2)
    }
    
    fileprivate func getDataSet(val: [Pair],label: String,color: NSUIColor) -> ScatterChartDataSet {
        var values: [ChartDataEntry] = []
        for i in 0..<val.count {
            let dot = ChartDataEntry(x: Double(i), y: val[i].value)
            values.append(dot)
        }
        let set = ScatterChartDataSet(values: values, label: label)
        set.setScatterShape(.square)
        set.setColor(color)
        set.scatterShapeSize = 8
        return set
    }
    
    fileprivate func raisePropertyChanged()
    {
        if dataChart == nil {
            return
        }
        var currencies: [String] = []
        for item in dataChart.d1 {
            currencies.append(item.key)
        }
        DispatchQueue.main.async(execute: {() -> Void in
            self.dotsChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: currencies)
            self.chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: currencies)
            self.dotsChart.isHidden = true
            self.chartView.isHidden = true
            
            switch self.segmentController.selectedSegmentIndex
            {
            case 0:
                self.chartView.isHidden = false
                
                self.setBarChart(values: self.dataChart.m15)
            case 1:
                self.chartView.isHidden = false
                self.setBarChart(values: self.dataChart.h1)
            case 2:
                self.chartView.isHidden = false
                self.setBarChart(values: self.dataChart.h4)
            case 3:
                self.chartView.isHidden = false
                self.setBarChart(values: self.dataChart.d1)
            case 4:
                self.dotsChart.isHidden = false
                self.setDotsChart()
            default:
                break
            }
        })
        
    }

    @objc fileprivate func getRequest() {
        guard let url = URL(string: "http://91.194.90.62:20019/fxservice/strongweak") else { return }
        let session = URLSession.shared
        session.dataTask(with: url) { (data , response ,error) in
            if let data = data
            {
                do
                {
                    let json = try JSONDecoder().decode(DataChart.self, from: data)
                    self.dataChart = json
                    self.raisePropertyChanged()
                }
                catch{
                    print(error)
                }
            }
        }.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

