
import UIKit
import SnapKit

class CitySearchCell: UITableViewCell {
    static let id = "CitySearchCell"
    
    private let cityLable: UILabel = {
        let label = UILabel()
        label.text = "샌프란시스코"
        label.textColor = .textColor
        label.font = .monospacedDigitSystemFont(ofSize: 20, weight: .thin)
        label.textAlignment = .left
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
        [cityLable].forEach { addSubview($0) }
    }
    private func setConstraints() {
        cityLable.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configure() {
        
    }
    
}
