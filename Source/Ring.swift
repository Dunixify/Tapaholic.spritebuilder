//  Ring.swift
//  Project: Tapaholic
//  Created by Vikram on 5/21/15.


import UIKit

public extension Float {
    /**
    Returns a random floating point number between 0.0 and 1.0, inclusive.
    By DaRkDOG
    */
    public static func random() -> Float {
        return Float(arc4random()) / 0xFFFFFFFF
    }
    /**
    By DaRkDOG
    */
    public static func random(#min: Float, max: Float) -> Float {
        return Float.random() * (max - min) + min
    }
}

class Ring: CCNode {
    //variable declerations
    var firstRing:CCSprite; //static ring
    var secondRing:CCSprite; //growing ring
    var speed:Double; //speed for CCActions
    var timeForFade:CCTime;//time for first ring to fade into/out of visibility
    var timeForScale:CCTime; //time for second ring to scale to size
    var fadeInFirstRing:CCActionFadeIn; //static ring fade in action
//    var fadeRingOut = CCActionFadeOut(); //static & growing ring fade out action
    var scaleSecondRing:CCActionScaleTo; //growing ring scaling action
    var points:Float; //points scores on this ring
    let maxPoints:Float; //max possible points for perfect tap
    var miss:Bool; //is this ring a miss?
    let maxScale:Float; //largest possible scale for second ring
    var scaleActionEnded:Bool; //is the second ring still scaling up?
    var screenSize:CGSize = CCDirector.sharedDirector().viewSizeInPixels(); //screen size in pixels
    
    //variable initializations
    init(s:Double) {
        speed=s;
        points = 0;
        maxPoints = 100.0;
        miss = false;
        scaleActionEnded = false;
        timeForFade = CCTime(0.25/speed);
        timeForScale = CCTime(1.5/speed);
        fadeInFirstRing = CCActionFadeIn(duration: timeForFade);
//        fadeRingOut = CCActionFadeOut(duration: timeForFade);
        
        //choosing rings' colors
        var color:UInt32 = arc4random_uniform(3)
        switch(color){
        case(0):
            firstRing = CCSprite(imageNamed: "ring_red.png");
            var secondColor:UInt32 = arc4random_uniform(2)
            switch(secondColor){
            case(0):
                secondRing = CCSprite(imageNamed: "ring_green.png");
            case(1):
                secondRing = CCSprite(imageNamed: "ring_blue.png");
            default:
                secondRing = CCSprite(imageNamed: "ring_yellow.png");
            }
        case(1):
            firstRing = CCSprite(imageNamed: "ring_green.png");
            var secondColor:UInt32 = arc4random_uniform(2)
            switch(secondColor){
            case(0):
                secondRing = CCSprite(imageNamed: "ring_red.png");
            case(1):
                secondRing = CCSprite(imageNamed: "ring_blue.png");
            default:
                secondRing = CCSprite(imageNamed: "ring_yellow.png");
            }
        case(2):
            firstRing = CCSprite(imageNamed: "ring_yellow.png");
            var secondColor:UInt32 = arc4random_uniform(2)
            switch(secondColor){
            case(0):
                secondRing = CCSprite(imageNamed: "ring_green.png");
            case(1):
                secondRing = CCSprite(imageNamed: "ring_blue.png");
            default:
                secondRing = CCSprite(imageNamed: "ring_red.png");
            }
        default:
            firstRing = CCSprite(imageNamed: "ring_blue.png");
            var secondColor:UInt32 = arc4random_uniform(2)
            switch(secondColor){
            case(0):
                secondRing = CCSprite(imageNamed: "ring_green.png");
            case(1):
                secondRing = CCSprite(imageNamed: "ring_red.png");
            default:
                secondRing = CCSprite(imageNamed: "ring_yellow.png");
            }
        }
        //rings initiall values
        firstRing.zOrder = 1;
        secondRing.zOrder = 2;
        firstRing.opacity = 0.0;
        firstRing.scale = Float.random(min: 0.45, max: 1.0);
        maxScale = secondRing.scale + (0.2 * secondRing.scale);
        secondRing.opacity = 0.0;
        secondRing.scale = 0.0;
        scaleSecondRing = CCActionScaleTo(duration: timeForScale, scale: maxScale);
        
    }
    
    func randInt (lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    
    override func onEnter() {
        //set random position
        var randX:Int = self.randInt(0, upper: Int(screenSize.width - firstRing.boundingBox().size.width + 1));
        var randY:Int = self.randInt(0, upper: Int(screenSize.height - firstRing.boundingBox().size.height + 1));
    //    self.position.x = CGFloat(randX) + (firstRing.boundingBox().size.width / 2);
    //    self.position.y = CGFloat(randY) + (firstRing.boundingBox().size.height / 2);
        firstRing.position.x = 0;
        firstRing.position.y = 0;
        secondRing.position.x = 0;
        secondRing.position.x = 0;
        //fade in first ring, show & scale second ring
        self.addChild(firstRing);
        self.addChild(secondRing);
        firstRing.runAction(fadeInFirstRing);
        secondRing.opacity = 1.0;
        self.userInteractionEnabled = true;
        secondRing.runAction(scaleSecondRing);
        scaleActionEnded = false;
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        //retrieving touch location
        //var touchLocation:CGPoint = touch.locationInNode(self);
        //stop second ring growth
        secondRing.stopAction(scaleSecondRing);
        //points calculation based on scale of second ring relative to first ring
        points = maxPoints - (maxPoints*(abs(secondRing.scale-firstRing.scale)));
        if(points <= 0.0){
            points = 0.0;
            miss = true;
        }
        scaleActionEnded = true;
        //sets points for this ring
        points = maxPoints - (abs(self.scale - 1) * maxPoints);
        //fade rings out
//        firstRing.runAction(fadeRingOut);
//        secondRing.runAction(fadeRingOut);
    }
    
    override func update(delta: CCTime) {
        // if second ring is at maxScale, award no points and count as miss
        if(secondRing.scale==maxScale){
            points = 0.0;
            miss = true;
            scaleActionEnded = true;
        }
    }
}