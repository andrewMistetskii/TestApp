//
//  DashLineView.swift
//  TestApp
//
//  Created by Andrzej Mistetskij on 7/13/16.
//  Copyright © 2016 Swift Devils. All rights reserved.
//

import UIKit
import CoreGraphics

class DashLineView: UIView {
    override func drawRect(rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let thickness: CGFloat = 2.0
        CGContextSetLineWidth(context, thickness)
        CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor)
        let  dashes: [CGFloat] = [9 , 4]
        CGContextSetLineDash(context, 0.0, dashes, 2)
        CGContextMoveToPoint(context, 0,thickness * 0.5)
        CGContextAddLineToPoint(context, self.bounds.size.width, thickness * 0.5)
        CGContextStrokePath(context)
    }
}
