//
//  ViewController.swift
//  HUTChart
//
//  Created by Hut on 2022/4/9.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var hutScrollView: HUTBarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        let graLayer = CAGradientLayer()
//        graLayer.frame = hutScrollView.bounds
//        graLayer.colors = [UIColor.red.cgColor, UIColor.green.cgColor]
//        graLayer.startPoint = CGPoint(x: 0, y: 0.5)
//        graLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
//        hutScrollView.layer.addSublayer(graLayer)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.hutScrollView.frame = self.hutScrollView.frame
    }
    
    @IBAction func redrawGraphic(_ sender: Any) {
        self.hutScrollView.frame = self.hutScrollView.frame
    }
    
    @IBOutlet weak var redrawLaine: UIButton!
}

