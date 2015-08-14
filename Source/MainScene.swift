import Foundation

class MainScene: CCScene {
    var speed:Double = 1.0; //actions' speed for rings
    var time:Int = 0; //current time in frames
    let minTimeInterval = 25; //minimum time between rings
    var points:CGFloat = 0; //points in current game
    var misses:Int = 0; //misses in current game
    //random delay generation related variables & constants
    let arc4randoMax:Double = 0x100000000;
    let upper = 1.5;
    let lower = 0.0;
    let maxPoints:CGFloat = 10.0;
    let maxScale:CGFloat = 1.2;
    let staticScale:CGFloat = 1.0;
//    var delayTime:Float32;
//    var delayCCTime:CCTime;
//    var delay:CCActionDelay;
    var Rings=[Ring]();
    var winSize = CCDirector.sharedDirector().viewSize();

    func spawnRingPair(){
        //find random position within screen that doesn't overlap with other Rings
        //spawn a ring in that position if Rings contains less than 4 rings
        var delayTime = Float32((Double(arc4random()) / arc4randoMax) * (upper - lower) + lower);
        var delayCCTime = CCTime(Double(delayTime));
        var delay = CCActionDelay(duration: delayCCTime);
        runAction(delay);
        
        var innerRing = Ring();
        var outerRing = Ring();
        Rings.append(outerRing);
        Rings.append(innerRing);
        outerRing.outerRing = true;
        var outerRingColor:UInt32 = arc4random_uniform(3);
        var innerRingColor:UInt32 = arc4random_uniform(2);
        
        switch(outerRingColor){
        case(0):
            outerRing.spriteFrame = CCSpriteFrame(imageNamed: "ring_red.png");
            switch(innerRingColor){
            case(0):
                innerRing.spriteFrame = CCSpriteFrame(imageNamed: "ring_green.png");
            case(1):
                innerRing.spriteFrame = CCSpriteFrame(imageNamed: "ring_blue.png");
            default:
                innerRing.spriteFrame = CCSpriteFrame(imageNamed: "ring_yellow.png");
            }
        case(1):
            outerRing.spriteFrame = CCSpriteFrame(imageNamed: "ring_green.png");
            switch(innerRingColor){
            case(0):
                innerRing.spriteFrame = CCSpriteFrame(imageNamed: "ring_red.png");
            case(1):
                innerRing.spriteFrame = CCSpriteFrame(imageNamed: "ring_blue.png");
            default:
                innerRing.spriteFrame = CCSpriteFrame(imageNamed: "ring_yellow.png");
            }
        case(2):
            outerRing.spriteFrame = CCSpriteFrame(imageNamed: "ring_blue.png");
            switch(innerRingColor){
            case(0):
                innerRing.spriteFrame = CCSpriteFrame(imageNamed: "ring_green.png");
            case(1):
                innerRing.spriteFrame = CCSpriteFrame(imageNamed: "ring_red.png");
            default:
                innerRing.spriteFrame = CCSpriteFrame(imageNamed: "ring_yellow.png");
            }
        default:
            outerRing.spriteFrame = CCSpriteFrame(imageNamed: "ring_yellow.png");
            switch(innerRingColor){
            case(0):
                innerRing.spriteFrame = CCSpriteFrame(imageNamed: "ring_green.png");
            case(1):
                innerRing.spriteFrame = CCSpriteFrame(imageNamed: "ring_blue.png");
            default:
                innerRing.spriteFrame = CCSpriteFrame(imageNamed: "ring_red.png");
            }
        }
        
        var minY = outerRing.contentSize.height/2;
        var maxY = winSize.height - outerRing.contentSize.height/2;
        var rangeY = maxY - minY;
        var actualY = CGFloat(arc4random()) % rangeY + minY;
        
        var minX = outerRing.contentSize.width/2;
        var maxX = winSize.width - outerRing.contentSize.width/2;
        var rangeX = maxX - minX;
        var actualX = CGFloat(arc4random()) % rangeX + minX;
        
        outerRing.position = ccp(actualX, actualY);
        innerRing.position = outerRing.position;
        
        addChild(outerRing);
        addChild(innerRing);
        
        var fadeTime = CCTime(0.5/speed);
        var fade = CCActionFadeIn(duration:fadeTime);
        outerRing.runAction(fade);
        innerRing.runAction(fade);
        
        var scaleTime = CCTime(1);
        var scaleinnerRing = CCActionScaleTo(duration: scaleTime, scale: 1.2);
        
        NSLog("Ring pair added");

        
    }
   
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        for ring in Rings{
            if(ring.touched == true){
                if(ring.outerRing == true){
                    ring.removeFromParent();
                    continue;
                }
                    var tempPoints = maxPoints - (maxPoints*(abs(staticScale-CGFloat(ring.scale))));
                    points+=tempPoints;
                ring.removeFromParent();
            }
        }
    }
    override func update(delta: CCTime) {
        var fadeTime = CCTime(0.5/speed);
        var fadeRingOut = CCActionFadeOut(duration: fadeTime);
        if(misses>=3){
            //display "game over" screen (as a scene) with points and time, show top x highschore, buttons for main menu, retry, etc
            NSLog("Game Over");
            for Ring in Rings{
                Ring.runAction(fadeRingOut);
            }
            var delay = CCActionDelay(duration: fadeTime);
            removeAllChildren();
        }
        else{
            time++;
            speed += 0.001;
            if(time % minTimeInterval == 0){
                //random delay time between 0 and 1.5
                if(Rings.count<4){
                    spawnRingPair();
                }
            }
            for Ring in Rings{
                if(CGFloat(Ring.scale) == maxScale){
                    
                    Ring.runAction(fadeRingOut);
                    var delay = CCActionDelay(duration: fadeTime);
                    misses++;
                    Ring.removeFromParent();
                }
            }
        }
    }
    
}
