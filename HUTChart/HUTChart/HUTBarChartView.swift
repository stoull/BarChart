//
//  HUTBarChartView.swift
//  HUTChart
//
//  Created by Hut on 2022/4/9.
//

import UIKit

class HUTBarChartView: UIView {
    var coordinate: HUTBarCoordinateView = HUTBarCoordinateView()
    var chartView: HUTBarChartScrollView = HUTBarChartScrollView()
    
    var spaceBetweenCooridnateAndChart: CGFloat = 6.0

    override var frame: CGRect {
        get {return super.frame}
        set {
            super.frame = newValue
            setup()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(coordinate)
        self.addSubview(chartView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapChart(_:)))
        self.addGestureRecognizer(tapGesture)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addSubview(coordinate)
        self.addSubview(chartView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapChart(_:)))
        self.addGestureRecognizer(tapGesture)
        self.setup()
    }
    
    private func setup() {
        coordinate.frame = bounds
        let coordinateOffset = coordinate.minOffset+coordinate.indexTextAreaWidth+spaceBetweenCooridnateAndChart
        chartView.frame = CGRect(origin: CGPoint(x: coordinateOffset, y: 0), size: CGSize(width: bounds.width-2*coordinateOffset, height: bounds.height))
    }

    @objc func didTapChart(_ recognizer: UITapGestureRecognizer) {
        let locationInChart = recognizer.location(in: self.chartView)
        
        /*
         let width = self.view.frame.width / 4
         let aView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: width))
         let options = [
           .type(.up),
           .cornerRadius(width / 2),
           .animationIn(0.3),
           .blackOverlayColor(UIColor.red),
           .arrowSize(CGSize.zero)
           ] as [PopoverOption]
         let popover = Popover(options: options, showHandler: nil, dismissHandler: nil)
         popover.show(aView, fromView: self.leftBottomButton)
         */
        
        
        
        if let topPoint = self.chartView.didTapChart(at: locationInChart) {
        }
    }
}
