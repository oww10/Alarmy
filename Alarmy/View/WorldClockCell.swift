
import UIKit
import SnapKit

class WorldClockCell: UITableViewCell {
    static let id = "WorldClockCell"
    
    private let timeLable: UILabel = {
        let label = UILabel()
        label.text = "3:00"
        label.textColor = .textColor
        label.font = .monospacedDigitSystemFont(ofSize: 50, weight: .light)
        label.textAlignment = .right
        return label
    }()
    private let cityLable: UILabel = {
        let label = UILabel()
        label.text = "샌프란시스코"
        label.textColor = .textColor
        label.font = .monospacedDigitSystemFont(ofSize: 30, weight: .semibold)
        label.textAlignment = .left
        return label
    }()
    private let amLabel: UILabel = {
        let label = UILabel()
        label.text = "오후"
        label.textColor = .textColor
        label.font = .monospacedDigitSystemFont(ofSize: 25, weight: .thin)
        label.textAlignment = .right
        return label
    }()
    
    private var hStack = UIStackView()
    private var rStack = UIStackView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configureUI() {
        self.backgroundColor = .bgColor
        [hStack].forEach { contentView.addSubview($0) }
        [amLabel, timeLable].forEach { rStack.addArrangedSubview($0) }
        [cityLable, rStack].forEach { hStack.addArrangedSubview($0) }
        
        hStack.axis = .horizontal
        hStack.distribution = .fillEqually
        hStack.spacing = 12
        rStack.axis = .horizontal
        rStack.distribution = .fill
        rStack.spacing = 6
        rStack.alignment = .center
        amLabel.transform = CGAffineTransform(translationX: 0, y: 6)
    }
    
    private func setConstraints() {
        rStack.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
        }
        hStack.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    func configure(with data: (cityName: String, countryName: String, timeZoneID: String)) {
        guard let timeZone = TimeZone(identifier: data.timeZoneID) else { return }
        let now = Date()
        
        self.cityLable.text = data.cityName
        
        let timeFormatter = DateFormatter()
        timeFormatter.timeZone = timeZone
        timeFormatter.dateFormat = "hh:mm"
        let timeString = timeFormatter.string(from: now)
        self.timeLable.text = timeString
        
        let ampmFormatter = DateFormatter()
        ampmFormatter.timeZone = timeZone
        ampmFormatter.dateFormat = "a"
        let ampmString = ampmFormatter.string(from: now)
        self.amLabel.text = ampmString
    }
    
}
