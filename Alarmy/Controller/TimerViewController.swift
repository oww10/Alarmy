
import UIKit
import SnapKit


final class TimerViewController: UIViewController{

    private let timerView = TimerView()
    private var timerModel = TimerModel()
    private let notification = TimerNotification()
    private var timer: Timer?
    private var remainingSeconds: Int = 0
    
    private var currentState: ViewState = .selectTime{
        didSet{
            updateUIState()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = timerView
        settingPickerView()
        settingAddTarget()
        currentState = .selectTime
    }
    private func settingPickerView(){
        timerView.pickerView.delegate = self
        timerView.pickerView.dataSource = self
    }
    private func settingAddTarget(){
        timerView.startButton.addTarget(self, action: #selector(tappedStartButton), for: .touchUpInside)
        timerView.cancelButton.addTarget(self, action: #selector(tappedCancelButton), for: .touchUpInside)
    }
    @objc private func tappedStartButton(){
        let totalSeconds = timerModel.totalTimer
        remainingSeconds = totalSeconds
        
        notification.scheduleNotification(in: TimeInterval(totalSeconds))
        updateCountdownLabel() 
        startTimer()
    }
    @objc private func tappedCancelButton(){
        notification.cancelNotification()
        stopTimer()
    }
    
    private func startTimer(){
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        currentState = .Timer
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        currentState = .selectTime
    }
    
    @objc private func updateTimer(){
        if remainingSeconds > 0 {
            remainingSeconds -= 1
            updateCountdownLabel()
        } else {
            stopTimer()
        }
    }
    private func updateCountdownLabel() {
        let hours = remainingSeconds / 3600
        let minutes = (remainingSeconds % 3600) / 60
        let seconds = (remainingSeconds % 3600) % 60
        
        timerView.countdownLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    private func updateUIState(){
        switch currentState{
        case .selectTime:
            timerView.pickerView.isHidden = false
            timerView.countdownLabel.isHidden = true
        case .Timer:
            timerView.pickerView.isHidden = true
            timerView.countdownLabel.isHidden = false
        }
    }
}

extension TimerViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return timerModel.hours.count
        case 1:
            return timerModel.minutes.count
        case 2:
            return timerModel.seconds.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title: String
        switch component {
        case 0:
            title = "\(timerModel.hours[row]) 시"
        case 1:
            title = "\(timerModel.minutes[row]) 분"
        case 2:
            title = "\(timerModel.seconds[row]) 초"
        default:
            title = ""
        }
        return NSAttributedString(string: title, attributes: [.foregroundColor: UIColor.textColor])
    }
    
    
}

extension TimerViewController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let hoursNums = pickerView.selectedRow(inComponent: 0)
        let minutesNums = pickerView.selectedRow(inComponent: 1)
        let secondsNums = pickerView.selectedRow(inComponent: 2)
    
        timerModel.updateTimer(hour: hoursNums, minute: minutesNums, second: secondsNums)
    }
}
