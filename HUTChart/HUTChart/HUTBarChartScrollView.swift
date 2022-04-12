//
//  HUTBarChartScrollView.swift
//  HUTChart
//
//  Created by Hut on 2022/4/9.
//

import UIKit

class HUTBarChartScrollView: UIScrollView {
    var barChart: HUTBarChart?
    
    fileprivate var currentSelectValuePoint: CGPoint?
    fileprivate var popover: Popover?

    override var frame: CGRect {
        get {return super.frame}
        set {
            super.frame = newValue
            setup()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    func didTapChart(at point: CGPoint) -> CGPoint? {
        if let valuePoint = barChart?.barTopPoint(tapPoint: point) {
            return valuePoint
        } else {
            return nil
        }
    }
    
    private func showPopoverValueView(at point: CGPoint) {
//        let width = self.frame.width / 4
        let aView = UIView(frame: CGRect(x: 0, y: 0, width: 82.0, height: 50.0))
        let options = [
          .type(.up),
          .cornerRadius(10.0),
          .animationIn(0.2),
          .blackOverlayColor(UIColor.clear),
          .arrowSize(CGSize(width: 10.0, height: 10.0)),
          .dismissOnBlackOverlayTap(false),
          ] as [PopoverOption]
        self.popover = Popover(options: options, showHandler: nil, dismissHandler: nil)
        self.popover!.show(aView, point: point, inView: self)
    }
    
    private func createPopoverView() {
        let padding: CGFloat = 6.0
        let viewSize: CGSize = CGSize(width: 84.0, height: 52.0)
        let lableSize: CGSize = CGSize(width: viewSize.width-padding*2.0, height: 10.0)
        let titleLabel = UILabel(frame: CGRect(origin: CGPoint(x: padding, y: padding), size: lableSize))
        let amountLabel = UILabel(frame: CGRect(origin: CGPoint(x: padding, y: titleLabel.frame.maxY), size: lableSize))
        let moneyLabel = UILabel(frame: CGRect(origin: CGPoint(x: padding, y: amountLabel.frame.maxY), size: lableSize))
        titleLabel.textColor = kHexColor("343434")
        
        let titleAttr: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 9.0, weight: .medium), .foregroundColor: kHexColor("343434")]
        let amountAttr: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 9.0, weight: .medium), .foregroundColor: kHexColor("01E672")]
        let moneyAttr: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 9.0, weight: .medium), .foregroundColor: kHexColor("F3AE84")]
        
        let amountAttStr = NSMutableAttributedString()
        amountAttStr.append(NSAttributedString(string: "", attributes: amountAttr))
        amountAttStr.append(NSAttributedString(string: "", attributes: amountAttr))
        
        let moneyAttStr = NSMutableAttributedString()
        moneyAttStr.append(NSAttributedString(string: "", attributes: amountAttr))
        moneyAttStr.append(NSAttributedString(string: "", attributes: amountAttr))
        
        titleLabel.text = ""
        
        let aView = UIView(frame:CGRect(origin: .zero, size: viewSize))
        aView.addSubview(titleLabel)
        aView.addSubview(amountLabel)
        aView.addSubview(moneyLabel)
    }
    
    private func setup() {
        if let rBarChart = barChart {
            rBarChart.removeFromSuperview()
        }
        barChart = HUTBarChart(frame: self.bounds)
        
        self.contentSize = barChart!.bounds.size
        self.addSubview(barChart!)
    }

}
