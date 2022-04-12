//
//  HUTScrollView.swift
//  HUTChart
//
//  Created by Hut on 2022/4/9.
//

import UIKit

class HUTScrollView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    private func setup() {
        let panGueture = UIPanGestureRecognizer(target: self, action: #selector(movePanScrollView(_:)))
        self.addGestureRecognizer(panGueture)
    }
    
    
    private var panStartLocation: CGPoint = .zero
    private var originalCenter: CGPoint = .zero
    @objc func movePanScrollView(_ recognizer: UIPanGestureRecognizer) {
        let fingerLocation = recognizer.location(in: self)
        if recognizer.state == .began {
            print("began: \(fingerLocation)")
            panStartLocation = fingerLocation
        } else {
            let dx = panStartLocation.x - fingerLocation.x
            let dy = panStartLocation.y - fingerLocation.y
            let ds = sqrt(dx*dx + dy*dy)
            
            let centerPoint = CGPoint(x: originalCenter.x-dx, y: originalCenter.y)
            self.center = centerPoint
            print("ing: \(fingerLocation) dx:\(dx), dy:\(dy), ds: \(ds)")
        }
    }
}
