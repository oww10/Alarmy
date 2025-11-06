// 알람 알림

import Foundation
import UserNotifications

class AlarmNotification {
    static let shared = AlarmNotification()
    private init() {}
    
    func alarmNoti(date: Date, id: String) {
        let content = UNMutableNotificationContent()
        content.title = "알람"
        content.body = ""
        content.sound = UNNotificationSound(named: UNNotificationSoundName("iPhoneAlarm.wav"))
        
        let triggerDate = Calendar.current.dateComponents([.hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("알람 등록 실패")
            } else {
                print("알람 등록 성공")
            }
        }
    }
    
    func cancelAlarm(id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
    
}
