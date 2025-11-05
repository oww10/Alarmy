// 알람 목록

import Foundation
import SnapKit
import UIKit

class AlarmTableViewCell: UITableViewCell {
    static let identifier = "AlarmTableViewCell"
    
    private let timeLabel = UILabel()
    private let toggle = UISwitch()
    var switchChanged: ((Bool) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
        [timeLabel, toggle].forEach { contentView.addSubview($0) }
        
        timeLabel.textColor = .white
        timeLabel.font = .systemFont(ofSize: 36, weight: .medium)
        timeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        toggle.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        toggle.addTarget(self, action: #selector(didChangeSwitch), for: .valueChanged)
    }
    
    @objc private func didChangeSwitch() {
        switchChanged?(toggle.isOn)
    }
    
    func configure(with alarm: Alarm) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        timeLabel.text = formatter.string(from: alarm.date ?? Date())
        toggle.isOn = alarm.isOn
        
    }
}
