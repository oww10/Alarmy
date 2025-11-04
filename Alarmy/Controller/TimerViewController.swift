
import UIKit
import SnapKit


final class TimerViewController: UIViewController{
    
    private let dataPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    private let hours = Array(0...23)
    private let minutes = Array(0...59)
    private let seconds = Array(0...59)
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "타이머"
        label.font = .systemFont(ofSize: 44, weight: .heavy)
        label.textColor = .textColor
        return label
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.backgroundColor = .cancelBGColor
        button.setTitleColor(.cancelTextColor, for: .normal)
        button.layer.cornerRadius = 45
        return button
    }()
    
    private let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("시작", for: .normal)
        button.backgroundColor = .startBGColor
        button.setTitleColor(.startTextColor, for: .normal)
        button.layer.cornerRadius = 45
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bgColor
        dataPickerView.delegate = self
        dataPickerView.dataSource = self
        setupUI()
        cofigureLayout()
    }
    
    private func setupUI(){
        [timerLabel, dataPickerView,cancelButton,startButton].forEach{
            view.addSubview($0)
        }
        
    }
    private func cofigureLayout(){
        timerLabel.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.leading.equalToSuperview().inset(20)
        }
        dataPickerView.snp.makeConstraints{ make in
            make.top.equalTo(timerLabel.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }
        cancelButton.snp.makeConstraints{ make in
            make.top.equalTo(dataPickerView.snp.bottom).offset(50)
            make.leading.equalToSuperview().inset(20)
            make.width.height.equalTo(90)
        }
        startButton.snp.makeConstraints{ make in
            make.top.equalTo(cancelButton)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(90)
        }
    }

}

extension TimerViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return hours.count
        case 1:
            return minutes.count
        case 2:
            return seconds.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title: String
        switch component {
        case 0:
            title = "\(hours[row]) 시"
        case 1:
            title = "\(minutes[row]) 분"
        case 2:
            title = "\(seconds[row]) 초"
        default:
            title = ""
        }
        return NSAttributedString(string: title, attributes: [.foregroundColor: UIColor.textColor])
    }
}
