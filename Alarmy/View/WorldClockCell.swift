
import UIKit
import SnapKit

class WorldClockCell: UITableViewCell {
    static let id = "WorldClockCell"
    
    private let timeLable: UILabel = {
        let label = UILabel()
        label.text = "3:00"
        label.textColor = .textColor
        label.font = .monospacedDigitSystemFont(ofSize: 70, weight: .thin)
        label.textAlignment = .right
        return label
    }()
    private let cityLable: UILabel = {
        let label = UILabel()
        label.text = "샌프란시스코"
        label.textColor = .textColor
        label.font = .monospacedDigitSystemFont(ofSize: 25, weight: .thin)
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
        [timeLable, cityLable, amLabel].forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        timeLable.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
        cityLable.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(timeLable.snp.centerY)
        }
        amLabel.snp.makeConstraints {
            $0.trailing.equalTo(timeLable.snp.leading)
            $0.top.equalTo(timeLable.snp.centerY)
        }
    }
    
    func configure() {
        
    }
    
}
