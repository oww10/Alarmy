// 알람 편집

import Foundation
import UIKit
import SnapKit

class EditViewController: UIViewController {
    private let mainLabel = UILabel()
    private lazy var picker = UIDatePicker()
    private let repeatLabel = UILabel()
    private let days = ["일", "월", "화", "수", "목", "금", "토"]
    private let dayButtons: [UIButton] = (0..<7).map { _ in UIButton() }
    private let stackView = UIStackView()
    private let alarmLabel = UILabel()
    private let textfield = UITextField()
    private let alarmToEdit: Alarm?
    weak var delegate: EditViewControllerDelegate?


    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        configureUI()
        configureStack()
    }
    
    init(alarm: Alarm? = nil) {
        self.alarmToEdit = alarm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        [mainLabel, picker, repeatLabel, stackView, alarmLabel, textfield]
            .forEach { view.addSubview($0) }
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "취소",
            style: .plain,
            target: self,
            action: #selector(cancelButtonTapped)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "저장",
            style: .plain,
            target: self,
            action: #selector(storeButton)
        )
        
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
        
        alarmLabel.text = "레이블"
        alarmLabel.textColor = .white
        alarmLabel.font = .systemFont(ofSize: 20, weight: .regular)
        alarmLabel.snp.makeConstraints {
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
            $0.top.equalTo(alarmLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(370)
            $0.height.equalTo(37)
        }
        
    }
    
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
    
  
    
    @objc private func cancelButtonTapped() { dismiss(animated: true) }
    
    @objc private func storeButton() {
        let date = picker.date
        let repeatDays = dayButtons.enumerated().compactMap { index, button in
            button.isSelected ? index : nil
        }
        let alarmLabel = alarmLabel.text ?? ""
        
        CoreDataManager.shared.createData(date: date, alarmLabel: alarmLabel, repeatDays: repeatDays)
        
        dismiss(animated: true) { [weak self] in
            guard let self else { return }
            self.delegate?.didUpdateAlarm()
        }
    }
    
    @objc private func dayButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        sender.backgroundColor = sender.isSelected ? UIColor(red: 41/255.0, green: 41/255.0, blue: 41/255.0, alpha: 1.0) : UIColor.selectBGColor
    }
}
