//
//  Ring.swift
//  Tapaholic
//
//  Created by Vikram on 8/13/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation
class Ring:CCSprite{
    
    var outerRing = false;
    var touched = false;
    var scaleActionEnded = false;
    
    convenience override init(){
        self.init(imageNamed:"ring_red.png");
        userInteractionEnabled = true;
        opacity = 0;
        position = CGPoint(x:0, y:0);
    }
   
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        touched = true;
    }
}