import Foundation

class MainScene: CCNode {
    var speed:Double; //actions' speed for rings
    var time:Int; //current time in frames
    let minTimeInterval:Int; //minimum time between rings
    var points:Int; //points in current game
    var misses:Int; //misses in current game
    //random delay generation related variables & constants
    let arc4randoMax:Double = 0x100000000;
    let upper = 1.5;
    let lower = 0.0;
    var delayTime:Float32;
    var delayCCTime = CCTime();
    var delay = CCActionDelay();
    var Rings=[Ring]();
    
    override init() {
        misses = 0;
        points = 0;
        delayTime = 0;
        minTimeInterval = 25;
        speed = 1.0;
        time = 0;
    }
    
    override func update(delta: CCTime) {
        time++;
        speed = speed + 0.001;
        if(time % minTimeInterval == 0){
            //random delay time between 0 and 1.5
            delayTime = Float32((Double(arc4random()) / arc4randoMax) * (upper - lower) + lower);
            delayCCTime = CCTime(Double(delayTime));
            //CCDelaybetween rings
            delay = CCActionDelay(duration: delayCCTime);
            self.runAction(delay);
            Rings.append(Ring(s: speed));
            self.addChild(Rings.last);
        }
        for Ring in Rings{
            if(Ring.miss == true){
                if(Ring.miss == true){
                    misses++;
                    self.removeChild(Ring);
                }
                else{
                    //add points earned from ring & delete ring
                    points += Int(Ring.points);
                    self.removeChild(Ring);
                }
            }
        }
    }
    
}
