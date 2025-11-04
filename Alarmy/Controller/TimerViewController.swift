
import UIKit
import SnapKit


final class TimerViewController: UIViewController{

    private let timerView = TimerView()
    private var timerModel = TimerModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = timerView
        settingPickerView()
        settingAddTarget()
        
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
        
    }
    @objc private func tappedCancelButton(){
        timerModel.updateTimer(hour: 0, minute: 0, second: 0)
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
