
import Foundation

struct TimerModel{
    let hours = Array(0...23)
    let minutes = Array(0...59)
    let seconds = Array(0...59)
    
    var setHour = 0
    var setMinute = 0
    var setSecond = 0
    
    var totalTimer: Int{
        return (setHour * 3600) + (setMinute * 60) + setSecond
    }
    
    mutating func updateTimer(hour: Int, minute: Int, second: Int){
        self.setHour = hour
        self.setMinute = minute
        self.setSecond = second
    }
}
