import Foundation
//delays may be interfering with touches
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
    var ptsLabel = CCLabelTTF();
    var missesLabel = CCLabelTTF();
//    override convenience init(){
//        self.init();
//        //userInteractionEnabled = true;
//    }
    
    override init(){
        super.init();
//    //    schedule(selector:update, interval: CCTime());
//    //    userInteractionEnabled = true;
    }
    
    override func onEnter() {
        super.onEnter();
        self.userInteractionEnabled = true;
    //    self.schedule(selector:update, interval: CCTime(1/60));
    }
    
    func spawnRingPair(){
        //find random position within screen that doesn't overlap with other Rings
        //spawn a ring in that position if Rings contains less than 4 rings
        let delayTime = Float32((Double(arc4random()) / arc4randoMax) * (upper - lower) + lower);
        let delayCCTime = CCTime(Double(delayTime));
        let delay = CCActionDelay(duration: delayCCTime);
        runAction(delay);
        
        let innerRing = Ring();
        let outerRing = Ring();
        outerRing.outerRing = true;
        let outerRingColor:UInt32 = arc4random_uniform(3);
        let innerRingColor:UInt32 = arc4random_uniform(2);
        
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
        
        let minY = outerRing.contentSize.height/2;
        let maxY = winSize.height - outerRing.contentSize.height/2;
        let rangeY = maxY - minY;
        let actualY = CGFloat(arc4random()) % rangeY + minY;
        
        let minX = outerRing.contentSize.width/2;
        let maxX = winSize.width - outerRing.contentSize.width/2;
        let rangeX = maxX - minX;
        let actualX = CGFloat(arc4random()) % rangeX + minX;
        
        outerRing.position = ccp(actualX, actualY);
        innerRing.position = outerRing.position;
        innerRing.scale = 0.3;

        addChild(outerRing);
        addChild(innerRing);
        Rings.append(outerRing);
        Rings.append(innerRing);
        let fadeTime = CCTime(0.5/speed);
        let fadeOuter = CCActionFadeIn(duration:fadeTime);
        let fadeInner = CCActionFadeIn(duration:fadeTime);
        
        outerRing.runAction(fadeOuter);
        innerRing.runAction(fadeInner);
        
        let scaleTime = CCTime(3.0/speed);
        let scaleInnerRing = CCActionScaleTo(duration: scaleTime, scale: 1.2);
        innerRing.runAction(scaleInnerRing);
        NSLog("Ring pair added");
    }
   
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        NSLog("Touch detected");
        let touchLocation = touch.locationInNode(self);
        var touchConvertedToRing = convertToNodeSpace(touchLocation);
//        for (index,ring) in enumerate(Rings){
//            if(ring.outerRing==false){
//                if(ring.boundingBox().contains(touchConvertedToRing)){
//              //  if(ring.boundingBox().contains(touchLocation)){
//                    var tempScale = Rings[index-1].scale;
//                    var tempPoints = maxPoints - (maxPoints*(abs(CGFloat(tempScale-ring.scale))));
//                    points+=tempPoints;
//                    ring.removeFromParent();
//                    Rings[index-1].removeFromParent();
//                    Rings.removeAtIndex(index);
//                    Rings.removeAtIndex(index-1);
//                    updateLabels();
//                }
//            }
//        }
        for (index,ring) in Rings.enumerate(){
            if(ring.touched == true){
                if(ring.outerRing == true){
                    let tempScale = Rings[index+1].scale;
                    let tempPoints = maxPoints - (maxPoints*(abs(CGFloat(ring.scale-tempScale))));
                    points+=tempPoints;
                    Rings[index+1].removeFromParent();
                    ring.removeFromParent();
                    Rings.removeAtIndex(index+1);
                    Rings.removeAtIndex(index);
                    updateLabels();
                    
                }
                else{
                    let tempScale = Rings[index-1].scale;
                    let tempPoints = maxPoints - (maxPoints*(abs(CGFloat(tempScale-ring.scale))));
                    points+=tempPoints;
                    ring.removeFromParent();
                    Rings[index-1].removeFromParent();
                    Rings.removeAtIndex(index);
                    Rings.removeAtIndex(index-1);
                    updateLabels();
                }
            }
        }
    }
    func updateLabels(){
        ptsLabel.string = "\(points)";
        missesLabel.string = "\(misses)";
    }
    override func update(delta: CCTime) {
        userInteractionEnabled = true;
        let fadeTime = CCTime(0.5/speed);
        let fadeOuterRing = CCActionFadeOut(duration: fadeTime);
        let fadeInnerRing = CCActionFadeOut(duration: fadeTime);
      
        if(misses>=3){
            //display "game over" screen (as a scene) with points and time, show top x highschore, buttons for main menu, retry, etc
            NSLog("Game Over");
//            for Ring in Rings{
//                Ring.runAction(fadeRingOut);
//            }
//            var delay = CCActionDelay(duration: fadeTime);
//            removeAllChildren();
        }
        else{
            time++;
            speed += 0.001;
            if(time % minTimeInterval == 0){
                //random delay time between 0 and 1.5
                if(Rings.count<8){
                    spawnRingPair();
                }
            }
            for (index,Ring) in Rings.enumerate(){
                if(CGFloat(Ring.scale) == maxScale){
                    Rings[index-1].runAction(fadeOuterRing);
                    Ring.runAction(fadeInnerRing);
                    var delay = CCActionDelay(duration: fadeTime);
                    misses++;
                    Rings[index-1].removeFromParent();
                    Ring.removeFromParent();
                    Rings.removeAtIndex(index);
                    Rings.removeAtIndex(index-1);
                    updateLabels();
                }
            }
        }
    }
    
}
