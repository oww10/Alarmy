// 알람 목록

import Foundation
import SnapKit
import UIKit

class AlarmTableViewCell: UITableViewCell {
    static let identifier = "AlarmTableViewCell"
    
    let timeLabel = UILabel()
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
        timeLabel.font = .systemFont(ofSize: 36, weight: .regular)
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
    
    @objc private func didChangeSwitch(_ sender: UISwitch) {
        switchChanged?(sender.isOn)
    }
    
    func configure(with alarm: Alarm) {
        // 시간을 오전/오후 단위로 포맷
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a hh:mm"
        timeLabel.text = formatter.string(from: alarm.date ?? Date())
        toggle.isOn = alarm.isOn
        
    }
}
