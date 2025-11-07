
import UIKit


class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        view.backgroundColor = .bgColor
       
    }
    
    private func setupTabs(){
        let worldClockVC = UINavigationController(rootViewController: WorldClockViewController())
        let alarmVC = UINavigationController(rootViewController: AlarmViewController())
        let stopWatchVC = UINavigationController(rootViewController: StopWatchViewController())
        let timerVC = UINavigationController(rootViewController: TimerViewController())
        let appearance = UITabBarAppearance()
        
        worldClockVC.tabBarItem = UITabBarItem(
            title: "세계 시간",
            image: UIImage(systemName: "globe"),
            selectedImage: UIImage(systemName: "globe.fill"))
        
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
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        tabBar.tintColor = .orange
        tabBar.unselectedItemTintColor = .gray
        tabBar.standardAppearance = appearance
        
        self.viewControllers = [worldClockVC, alarmVC, stopWatchVC, timerVC]
    }
}

