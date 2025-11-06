// 알람 편집

import Foundation
import UIKit
import SnapKit
import UserNotifications

class EditViewController: UIViewController {
    private let mainLabel = UILabel()
    private lazy var picker = UIDatePicker()
    private let repeatLabel = UILabel()
    private let days = ["일", "월", "화", "수", "목", "금", "토"]
    private let dayButtons: [UIButton] = (0..<7).map { _ in UIButton() }
    private let stackView = UIStackView()
    private let labelText = UILabel()
    private let textfield = UITextField()
    var editedAlarm: Alarm?
    weak var delegate: EditViewControllerDelegate?
    
    init(alarm: Alarm? = nil) {
        self.editedAlarm = alarm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureUI()
        configureStack()
        editWithInfo()
    }

    private func configureUI() {
        [mainLabel, picker, repeatLabel, stackView, labelText, textfield]
            .forEach { view.addSubview($0) }
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self,action: #selector(cancelButtonTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonTapped))
        
        let ap = UINavigationBarAppearance()
        ap.configureWithOpaqueBackground()
        ap.backgroundColor = .black
        ap.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        let navBar = navigationController?.navigationBar
        navBar?.standardAppearance = ap
        navBar?.scrollEdgeAppearance = ap
        navBar?.compactAppearance = ap
        navigationItem.title = "알람 편집"
        
        
        if let sheetPresentationController = sheetPresentationController {
            sheetPresentationController.detents = [.large()]
        }
        
        picker.preferredDatePickerStyle = .wheels
        picker.datePickerMode = .time
        picker.minuteInterval = 1
        picker.locale = Locale(identifier: "ko_KR")
        picker.translatesAutoresizingMaskIntoConstraints = false
        overrideUserInterfaceStyle = .light
        picker.setValue(UIColor.white, forKey: "textColor")
        
        picker.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(100)
        }
        
        repeatLabel.text = "반복"
        repeatLabel.textColor = .white
        repeatLabel.font = .systemFont(ofSize: 20, weight: .regular)
        repeatLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(picker.snp.bottom).offset(40)
        }
        
        labelText.text = "레이블"
        labelText.textColor = .white
        labelText.font = .systemFont(ofSize: 20, weight: .regular)
        labelText.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(stackView.snp.bottom).offset(40)
        }
        
        textfield.attributedPlaceholder = NSAttributedString(
            string: "알람 ",
            attributes: [.foregroundColor: UIColor.lightGray]
        )
        textfield.textAlignment = .right
        textfield.textColor = UIColor(red: 144/255.0, green: 144/255.0, blue: 144/255.0, alpha: 1.0)
        
        textfield.borderStyle = .line
        textfield.backgroundColor = UIColor(red: 41/255.0, green: 41/255.0, blue: 41/255.0, alpha: 1.0)
        textfield.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        textfield.rightViewMode = .always
        textfield.snp.makeConstraints {
            $0.top.equalTo(labelText.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(370)
            $0.height.equalTo(37)
        }
        
    }
    
    // 반복 요일 버튼 스택
    private func configureStack() {
        for (index, button) in dayButtons.enumerated() {
            stackView.addArrangedSubview(button)
            let title = days[index]
            button.setTitle(title, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor(red: 41/255.0, green: 41/255.0, blue: 41/255.0, alpha: 1.0)
            button.layer.cornerRadius = 25
            button.snp.makeConstraints { $0.width.height.equalTo(50) }
            button.addTarget(self, action: #selector(dayButtonTapped(_:)), for: .touchUpInside)
        }
        
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.snp.makeConstraints {
            $0.top.equalTo(repeatLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
    }
    
    // 편집 화면
    private func editWithInfo() {
        guard let alarm = editedAlarm else { return }
        
        if let pickerDate = alarm.date {
            picker.date = pickerDate
        }
        textfield.text = alarm.alarmLabel
        
        let storeRepeatDays: [Int] = {
            if let ints = alarm.value(forKey: "repeatDays") as? [Int] { return ints }
            if let nums = alarm.value(forKey: "repeatDays") as? [NSNumber] { return nums.map(\.intValue)}
            return []
        }()
        
        for (i, btn) in dayButtons.enumerated() {
            let selected = storeRepeatDays.contains(i)
            setDayButton(btn, selected: selected)
        }
        
    }
    
    
    private func setDayButton(_ button: UIButton, selected: Bool) {
        button.isSelected = selected
        if selected {
            button.backgroundColor = UIColor.selectBGColor
        } else {
            button.backgroundColor = UIColor(red: 41/255, green: 41/255, blue: 41/255, alpha: 1)
        }
    }
    
    
    @objc private func cancelButtonTapped() { dismiss(animated: true) }
    
    @objc private func saveButtonTapped() {
        let date = picker.date
        let repeatDays = dayButtons.enumerated().compactMap { $1.isSelected ? $0 : nil }
        let labelText = textfield.text ?? ""

        if let alarm = editedAlarm {
            alarm.date = date
            alarm.alarmLabel = labelText
            alarm.repeatDays = repeatDays

            CoreDataManager.shared.saveContext()

            let id = alarm.objectID.uriRepresentation().absoluteString
            // 기존 스케줄 제거
            AlarmNotification.shared.cancelAlarm(id: id)
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [id])

            if alarm.isOn {
                AlarmNotification.shared.alarmNoti(date: date, id: id)
            }

        } else {
            // 기본 켜짐이면 true
            let newAlarm = CoreDataManager.shared.createData(date: date, alarmLabel: labelText, repeatDays: repeatDays, isOn: true)
            let newID = newAlarm.objectID.uriRepresentation().absoluteString
            AlarmNotification.shared.alarmNoti(date: date, id: newID)
        }

        dismiss(animated: true) { [weak self] in
            self?.delegate?.didUpdateAlarm()
        }
    }

    
    @objc private func dayButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        setDayButton(sender, selected: sender.isSelected)
        
    }
}
