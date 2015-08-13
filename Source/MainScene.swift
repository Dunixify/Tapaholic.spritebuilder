import Foundation

class MainScene: CCScene {
    var speed:Double; //actions' speed for rings
    var time:Int; //current time in frames
    let minTimeInterval:Int; //minimum time between rings
    var points:Int; //points in current game
    var misses:Int; //misses in current game
    //random delay generation related variables & constants
    let arc4randoMax:Double = 0x100000000;
    let upper = 1.5;
    let lower = 0.0;
//    var delayTime:Float32;
//    var delayCCTime:CCTime;
//    var delay:CCActionDelay;
    var Rings=[Ring]();
    
    override init() {
        misses = 0;
        points = 0;
//        delayTime = 0;
        minTimeInterval = 25;
        speed = 1.0;
        time = 0;
    }
    func spawnRing(){
        //find random position within screen that doesn't overlap with other Rings
        //spawn a ring in that position if Rings contains less than 4 rings
        
    }
    override func update(delta: CCTime) {
        if(misses>=3){
            //display "game over" screen (as a scene) with points and time, show top x highschore, buttons for main menu, retry, etc
            NSLog("Game Over");
        }
        else{
            time++;
            speed += 0.001;
            if(time % minTimeInterval == 0){
                //random delay time between 0 and 1.5
                var delayTime = Float32((Double(arc4random()) / arc4randoMax) * (upper - lower) + lower);
                var delayCCTime = CCTime(Double(delayTime));
                //CCDelaybetween rings
                var delay = CCActionDelay(duration: delayCCTime);
                self.runAction(delay);
                Rings.append(Ring(s: speed));
                self.addChild(Rings.last);
                NSLog("Ring added");
            }
            for Ring in Rings{
                if(Ring.scaleActionEnded == true){
                    if(Ring.miss == true){
                        misses++;
                    }
                    else{
                        //add points earned from ring & delete ring
                        points += Int(Ring.points);
                   }
                    var fadeTime = CCTime(0.5/speed);
                    var fadeRingOut = CCActionFadeOut(duration: fadeTime);
                    Ring.runAction(fadeRingOut);
                    self.removeChild(Ring);
                }
            }
        }
    }
    
}
