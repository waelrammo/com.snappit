//
//  GradientLayer.swift
//  SNAppIT
//
//  Created by Azat Almeev on 05.04.15.
//  Copyright (c) 2015 Azat Almeev. All rights reserved.
//

import UIKit

class BlueGradientView: UIView {
    override init() {
        super.init()
        addGradient()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addGradient()
    }
    
    private func addGradient() {
        self.backgroundColor = UIColor.clearColor()
        let colorTop = UIColor(hexString: "7fb0db").CGColor
        let colorBottom = UIColor(hexString: "547da0").CGColor
        let gl = CAGradientLayer()
        gl.colors = [ colorTop, colorBottom]
        gl.locations = [ 0.0, 1.0]
        gl.frame = self.frame
        self.layer.insertSublayer(gl, atIndex: 0)
    }
    
    override func layoutSublayersOfLayer(layer: CALayer!) {
        super.layoutSublayersOfLayer(layer)
        if (layer == self.layer) {
            let gl = layer.sublayers.first as CAGradientLayer
            gl.frame = CGRectMake(self.x, self.y, max(self.width, self.height), max(self.width, self.height))
        }
    }
}
