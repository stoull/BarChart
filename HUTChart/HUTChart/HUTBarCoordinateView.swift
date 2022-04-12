//
//  HUTBarCoordinateView.swift
//  HUTChart
//
//  Created by Hut on 2022/4/9.
//

import UIKit

class HUTBarCoordinateView: UIView {
    var leftIndexTitles: [String] = [String]()
    var leftUntiSymbol: String = "kWh"
    
    var rightIndexTitles: [String] = [String]()
    var rightUntiSymbol: String = "$"
    
    // background lines
    private var bg_line_space: CGFloat = 36.0
    private var last_bg_line_Y: CGFloat = 80.0
    
    // 边距的缩进
    var minOffset: CGFloat = 4.0
    var indexTextAreaWidth: CGFloat = 30.0
    var indexTextAreaHeight: CGFloat = 30.0

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
    
    private func setup() {
        bg_line_space = 0.1666*(frame.size.height - indexTextAreaHeight)
        last_bg_line_Y = frame.size.height - indexTextAreaHeight
        
        leftIndexTitles = ["0", "20", "40", "60", "80", "1000000"].reversed()
        rightIndexTitles = ["0", "10", "20", "30", "40", "5000"].reversed()
        
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {return}
        
        ctx.saveGState()
        let bgPath = UIBezierPath(rect: bounds)
        ctx.setFillColor(backgroundColor?.cgColor ?? UIColor.white.cgColor)
        ctx.addPath(bgPath.cgPath)
        ctx.fillPath()
        ctx.restoreGState()
        
        UIGraphicsPushContext(ctx)
        
        let right_left_x = bounds.width - minOffset - indexTextAreaWidth
        let titleSize = CGSize(width: indexTextAreaWidth, height: 12)
        
        // for left side
        let leftPara = NSMutableParagraphStyle()
        leftPara.alignment = .right
        let leftTitleAtt:[NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 10.0, weight: .medium), .foregroundColor:kHexColor("#343434"), .paragraphStyle: leftPara]
        let leftSymbolStr = NSAttributedString(string: leftUntiSymbol, attributes: leftTitleAtt)
        leftSymbolStr.draw(in: CGRect(origin: CGPoint(x: minOffset, y: 0), size: titleSize))
        
        for index in 1...leftIndexTitles.count {
            let title = leftIndexTitles[index-1]
            let positionY = bg_line_space * CGFloat(index)
            let titleStr = NSAttributedString(string: title, attributes: leftTitleAtt)
            let tRect = CGRect(origin: CGPoint(x: minOffset, y: positionY-titleSize.height*0.5), size: titleSize)
            titleStr.draw(in: tRect)
        }
        
        // for right side
        let rightPara = NSMutableParagraphStyle()
        rightPara.alignment = .left
        let rightTitleAtt:[NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 10.0, weight: .medium), .foregroundColor:kHexColor("#343434"), .paragraphStyle: rightPara]
        let rightSymbolStr = NSAttributedString(string: rightUntiSymbol, attributes: rightTitleAtt)
        rightSymbolStr.draw(in: CGRect(origin: CGPoint(x: right_left_x, y: 0), size: titleSize))
        
        for index in 1...rightIndexTitles.count {
            let title = rightIndexTitles[index-1]
            let positionY = bg_line_space * CGFloat(index)
            let titleStr = NSAttributedString(string: title, attributes: rightTitleAtt)
            let tRect = CGRect(origin: CGPoint(x: right_left_x, y: positionY-titleSize.height*0.5), size: titleSize)
            titleStr.draw(in: tRect)
        }
        
        UIGraphicsPopContext()
    }
}
