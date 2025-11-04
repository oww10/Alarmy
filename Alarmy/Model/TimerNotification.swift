
import UserNotifications

struct TimerNotification{
    
    func scheduleNotification(in seconds: TimeInterval) {
        
        guard seconds > 0 else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "타이머 종료"
        content.body = "설정한 시간이 모두 지났습니다."
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "timer_notification",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("알림 실패: \(error.localizedDescription)")
            } else {
                print("\(seconds)초 후 알림 등록.")
            }
        }
    }
    
    func cancelNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["timer_notification"])
    }}



