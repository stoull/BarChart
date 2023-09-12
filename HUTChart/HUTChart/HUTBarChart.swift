//
//  HUTBarChart.swift
//  HUTChart
//
//  Created by Hut on 2022/4/9.
//

import UIKit

class HUTBarChart: UIView {
    // 边距的缩进
    var minOffset: CGFloat = 0.0
    var drageEnabled: Bool = true
    
    // bar
    var barWidth: CGFloat = 5.0
    var spaceBetweenBar: CGFloat = 16.0
    
    // line
    var lineWidth: CGFloat = 2.0
    
    var indexTextAreaHeight: CGFloat = 30.0
    private var indexTextLabeSize: CGSize = CGSize(width: 40.0, height: 30.0)
    
    var indexTitles: [String] = [String]()
    var data: [Float] = [Float]()
    private var barTopPoints: [CGPoint] = [CGPoint]()
    
    // background lines
    private var bg_line_count: Int = 6
    private var bg_line_space: CGFloat = 36.0
    private var last_bg_line_Y: CGFloat = 80.0
    
    private var highlightLayer = CAShapeLayer()
    
    /// Popover
    fileprivate var currentSelectValuePoint: CGPoint?
    fileprivate var popover: Popover?
    
    override var frame: CGRect {
        get {return super.frame}
        set {
            super.frame = newValue
            self.setNeedsDisplay()
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
    
    private func setup() {
        // test data
        indexTitles = Array(1...50).map{ String($0) }
        for _ in 0...49 {
            data.append(Float(Int.random(in: 0...100)))
        }
        
        bg_line_space = (1/CGFloat(bg_line_count))*(bounds.size.height - indexTextAreaHeight)
        last_bg_line_Y = frame.size.height - indexTextAreaHeight
        var viewWidth = (spaceBetweenBar*CGFloat(data.count-1)) + barWidth*CGFloat(data.count) + (minOffset*2.0)
        if viewWidth < frame.size.width {
            viewWidth = frame.size.width
        }
        let viewHeight = frame.size.height
        self.frame = CGRect(origin: .zero, size: CGSize(width: CGFloat(viewWidth), height: viewHeight))
    }

    /// Get the value point of the touching area
    open func barTopPoint(tapPoint location: CGPoint) -> CGPoint? {
        var index: Int = 0
        for topPoint in barTopPoints {
            let sPoint = CGPoint(x: topPoint.x - (spaceBetweenBar+barWidth)*0.5, y: topPoint.y)
            //  && (location.y >= sPoint.y && location.y <= last_bg_line_Y)
            if (location.x >= sPoint.x && location.x <= sPoint.x + spaceBetweenBar+barWidth) {
                self.higelightDot(point: topPoint)
                self.didUpdateNewValuePoint(at: topPoint, index: index)
                return topPoint
            }
            index += 1
        }
        self.didUpdateNewValuePoint(at: nil, index: 0)
        return nil
    }
    
    override func draw(_ rect: CGRect) {
    }
    
    override func draw(_ layer: CALayer, in ctx: CGContext) {
        if let subLayers = layer.sublayers {
            for subLayer in subLayers {
                subLayer.removeFromSuperlayer()
            }
        }
        
        ctx.saveGState()
        let bgPath = UIBezierPath(rect: bounds)
        ctx.setFillColor(backgroundColor?.cgColor ?? UIColor.white.cgColor)
        ctx.addPath(bgPath.cgPath)
        ctx.fillPath()
        ctx.restoreGState()
        
        let size = frame.size
        
        ctx.saveGState()
        let bg_linePath = UIBezierPath()
        bg_linePath.lineWidth = lineWidth
        for i in 1...bg_line_count {
            let x_position = CGFloat(bg_line_space)*CGFloat(i)
            bg_linePath.move(to: CGPoint(x: minOffset, y: x_position))
            bg_linePath.addLine(to: CGPoint(x: size.width-minOffset, y: x_position))
        }
        
        ctx.setStrokeColor(kHexColorA("000000", 0.15).cgColor)
        ctx.addPath(bg_linePath.cgPath)
        ctx.strokePath()
        ctx.restoreGState()
        
        /// draw index titles and
        let valueBarsPath = UIBezierPath()
        let valueLinesPath = UIBezierPath()
        UIGraphicsPushContext(ctx)
        indexTextLabeSize = CGSize(width: barWidth+spaceBetweenBar, height: 30)
        for index in 0...indexTitles.count-1 {
            let title = indexTitles[index]
            let titleStr = NSAttributedString(string: title, attributes: [.font: UIFont.systemFont(ofSize: 10.0, weight: .medium), .foregroundColor: kHexColor("#343434")])
            
            let topPoint = indexLabelCenterPoint(column: index)
            let titleRect = CGRect(origin: CGPoint(x: topPoint.x-barWidth*0.5, y: last_bg_line_Y+10.0), size: indexTextLabeSize)
            titleStr.draw(in: titleRect)
            
            valueBarsPath.move(to: CGPoint(x: topPoint.x, y: last_bg_line_Y-lineWidth*0.4))
            valueBarsPath.addLine(to: topPoint)
            if index == 0 {
                valueLinesPath.move(to: topPoint)
            } else {
                valueLinesPath.addLine(to: topPoint)
            }
            barTopPoints.append(topPoint)
        }
        UIGraphicsPopContext()
        
        let barsLayer = CAGradientLayer()
        self.layer.addSublayer(barsLayer)
        barsLayer.frame = bounds
        barsLayer.colors = [kHexColor("#01E672").cgColor, kHexColor("#85E6B5").cgColor]
        barsLayer.startPoint = CGPoint(x: 0.5, y: 0)
        barsLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        let barsShapeLayer = CAShapeLayer()
        barsShapeLayer.frame = bounds
        barsShapeLayer.lineWidth = barWidth
        barsShapeLayer.strokeColor = UIColor.black.cgColor
        barsShapeLayer.fillColor = UIColor.clear.cgColor
        barsShapeLayer.path = valueBarsPath.cgPath
        barsLayer.mask = barsShapeLayer
        
        
        let foldLineLayer = CAShapeLayer()
        foldLineLayer.frame = bounds
        foldLineLayer.lineWidth = lineWidth
        foldLineLayer.strokeColor = kHexColor("F3AE84").cgColor
        foldLineLayer.fillColor = UIColor.clear.cgColor
        foldLineLayer.path = valueLinesPath.cgPath
        foldLineLayer.lineJoin = .bevel
        self.layer.addSublayer(foldLineLayer)
    }
    
    private func indexLabelCenterPoint(column: Int) -> CGPoint {
        let pX = CGFloat(column)*spaceBetweenBar + CGFloat(column)*barWidth + minOffset + barWidth*0.5
        
        let pointValue = data[column]
        var maxValue:CGFloat = 0.0
        if let maxiValue = data.max() {
            maxValue = CGFloat(maxiValue)
        }
        
        if maxValue == 0.0 {
            maxValue = 10.0
        }
        
        var yPoint:CGFloat = 0.0
        if maxValue != 0.0 && self.frame.height != 0.0 {
            yPoint = CGFloat(pointValue) / CGFloat(maxValue) * (last_bg_line_Y - bg_line_space)
        }
        let pY = self.frame.height - indexTextAreaHeight - yPoint
        return CGPoint(x: pX, y: pY)
    }
}

extension HUTBarChart {
    
    private func didUpdateNewValuePoint(at point: CGPoint?, index: Int) {
        if let rPoint = point {
            if rPoint != self.currentSelectValuePoint {
                self.popover?.dismiss()
                self.showPopoverValueView(at: rPoint, index: index)
            }
            currentSelectValuePoint = rPoint
        } else {
            currentSelectValuePoint = nil
            self.popover?.dismiss()
        }
    }
    
    private func higelightDot(point: CGPoint) {
        remoteAllHighLight()
        highlightLayer.frame = bounds
        let dotPath = UIBezierPath()
        dotPath.move(to: point)
        dotPath.addLine(to: point)
        highlightLayer.lineWidth = 18.0
        highlightLayer.lineCap = .round
        highlightLayer.strokeColor = kHexColorA("F3AE84", 0.2).cgColor
        highlightLayer.fillColor = UIColor.clear.cgColor
        highlightLayer.path = dotPath.cgPath
        
        let highlightLayer2 = CAShapeLayer()
        highlightLayer2.frame = bounds
        highlightLayer2.lineWidth = 9.0
        highlightLayer2.lineCap = .round
        highlightLayer2.strokeColor = kHexColor("F3AE84").cgColor
        highlightLayer2.fillColor = UIColor.clear.cgColor
        highlightLayer2.path = dotPath.cgPath
        
        highlightLayer.addSublayer(highlightLayer2)
        
        self.layer.addSublayer(highlightLayer)
    }
    
    private func remoteAllHighLight() {
        if let sublayers = highlightLayer.sublayers {
            for subLayer in sublayers {
                subLayer.removeFromSuperlayer()
            }
        }
        
        highlightLayer.removeFromSuperlayer()
    }
    
    private func showPopoverValueView(at point: CGPoint, index: Int) {
//        let width = self.frame.width / 4
        let dateString = indexTitles[index]
        let amountString = String(data[index])
        
        var popoverType: PopoverType = .up
        
        let aView = self.createPopoverView(atPoint: point, date: "2022", amount: amountString, money: dateString)
        if point.y - aView.bounds.height < 5 {
            popoverType = .down
        }
        
        let options = [
          .type(popoverType),
          .cornerRadius(5.0),
          .animationIn(0.2),
          .blackOverlayColor(UIColor.clear),
          .arrowSize(CGSize(width: 10.0, height: 10.0)),
          .dismissOnBlackOverlayTap(false),
          ] as [PopoverOption]
        let pPoverView = Popover(options: options, showHandler: nil, dismissHandler: nil)
        
        pPoverView.layer.shadowColor = kHexColor("002A5D").cgColor
        pPoverView.layer.shadowOffset = CGSize(width: 0,height: 0)
        pPoverView.layer.shadowRadius = 5.0
        pPoverView.layer.shadowOpacity = 0.2
        pPoverView.layer.shadowPath = UIBezierPath(rect: aView.bounds).cgPath
        
        self.popover = pPoverView
        self.popover!.show(aView, point: point, inView: self)
    }
    
    private func createPopoverView(atPoint: CGPoint, date: String, amount: String, money: String) -> UIView {
        let padding: CGFloat = 4.0
        let viewSize: CGSize = CGSize(width: 86.0, height: 52.0)
        
        var titleOrigin_y: CGFloat = padding
        if atPoint.y - viewSize.height < 5 {
            titleOrigin_y = padding*4
        }
        
        let lableSize: CGSize = CGSize(width: viewSize.width-padding*2.0, height: 10.0)
        let titleLabel = UILabel(frame: CGRect(origin: CGPoint(x: padding, y: titleOrigin_y), size: lableSize))
        let amountLabel = UILabel(frame: CGRect(origin: CGPoint(x: padding, y: titleLabel.frame.maxY+4.0), size: lableSize))
        let moneyLabel = UILabel(frame: CGRect(origin: CGPoint(x: padding, y: amountLabel.frame.maxY+4.0), size: lableSize))
        titleLabel.textColor = kHexColor("343434")
        
        let titleAttr: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 9.0, weight: .medium), .foregroundColor: kHexColor("343434")]
        let amountAttr: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 9.0, weight: .medium), .foregroundColor: kHexColor("01E672")]
        let moneyAttr: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 9.0, weight: .medium), .foregroundColor: kHexColor("F3AE84")]
        
        let amountAttStr = NSMutableAttributedString()
        amountAttStr.append(NSAttributedString(string: "充电电量：", attributes: titleAttr))
        amountAttStr.append(NSAttributedString(string: amount, attributes: amountAttr))
        
        let moneyAttStr = NSMutableAttributedString()
        moneyAttStr.append(NSAttributedString(string: "充电费用：", attributes: titleAttr))
        moneyAttStr.append(NSAttributedString(string: money, attributes: moneyAttr))
        
        titleLabel.text = "2021.01"
        titleLabel.font = UIFont.systemFont(ofSize: 9.0, weight: .medium)
        amountLabel.attributedText = amountAttStr
        moneyLabel.attributedText = moneyAttStr
        
        let aView = UIView(frame:CGRect(origin: .zero, size: viewSize))
        aView.addSubview(titleLabel)
        aView.addSubview(amountLabel)
        aView.addSubview(moneyLabel)
        return aView
    }
}
