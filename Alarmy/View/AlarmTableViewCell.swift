// 알람 목록

import Foundation
import SnapKit
import UIKit

class AlarmTableViewCell: UITableViewCell {
    static let identifier = "AlarmTableViewCell"
    
    let timeLabel = UILabel()
    private let toggle = UISwitch()
    let savedLabel = UILabel()
    private let vStack = UIStackView()
    var switchChanged: ((Bool) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
        [toggle, vStack].forEach { contentView.addSubview($0) }
        [timeLabel, savedLabel].forEach { vStack.addArrangedSubview($0) }
        
        timeLabel.textColor = UIColor(red: 115/255.0, green: 115/255.0, blue: 115/255.0, alpha: 1.0)
        savedLabel.textColor = .lightGray
        savedLabel.font = .systemFont(ofSize: 15, weight: .regular)
        vStack.axis = .vertical
        vStack.distribution = .fill
        vStack.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        toggle.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        toggle.addTarget(self, action: #selector(didChangeSwitch), for: .valueChanged)
    }
    
    @objc private func didChangeSwitch(_ sender: UISwitch) {
        switchChanged?(sender.isOn)
    }
    
    func attributedTime(from date: Date) -> NSAttributedString {
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "ko_KR")
        fmt.amSymbol = "오전"
        fmt.pmSymbol = "오후"
        fmt.dateFormat = "a hh:mm"

        let full = fmt.string(from: date)
        let bigFont = UIFont.systemFont(ofSize: 55, weight: .light)
        let attr = NSMutableAttributedString(
            string: full,
            attributes: [.font: bigFont]
        )

        if let range = full.range(of: fmt.amSymbol) ?? full.range(of: fmt.pmSymbol) {
            let nsRange = NSRange(range, in: full)
            let smallFont = UIFont.systemFont(ofSize: 25, weight: .thin)
            attr.addAttributes([
                .font: smallFont,
                .baselineOffset: 1
            ], range: nsRange)
        }

        return attr
    }
    
    func configure(with alarm: Alarm) {
        timeLabel.attributedText = attributedTime(from: alarm.date ?? Date())
        savedLabel.text = alarm.alarmLabel
        toggle.isOn = alarm.isOn
        
    }
}
