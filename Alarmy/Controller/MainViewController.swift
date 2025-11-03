
import UIKit


class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        
    }

    private func setupTabs(){
        let alarmVC = UINavigationController(rootViewController: AlarmViewController())
        let stopWatchVC = UINavigationController(rootViewController: StopWatchViewController())
        let timerVC = UINavigationController(rootViewController: TimerViewController())
        
        alarmVC.tabBarItem = UITabBarItem(
            title: "알람",
            image: UIImage(systemName: "alarm"),
            selectedImage: UIImage(systemName: "alarm.fill"))
        
        stopWatchVC.tabBarItem = UITabBarItem(
            title: "스톱워치",
            image: UIImage(systemName: "stopwatch"),
            selectedImage: UIImage(systemName: "stopwatch.fill"))
        
        timerVC.tabBarItem = UITabBarItem(
            title: "타이머",
            image: UIImage(systemName: "timer"),
            selectedImage: UIImage(systemName: "timer.fill"))
        
        self.viewControllers = [alarmVC, stopWatchVC, timerVC]
    }
}

