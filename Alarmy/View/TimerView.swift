
import UIKit
import SnapKit

final class TimerView: UIView {
    private let animationKey = "strokeEndAnimation"
    
    let pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "타이머"
        label.font = .systemFont(ofSize: 44, weight: .heavy)
        label.textColor = .textColor
        return label
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.backgroundColor = .cancelBGColor
        button.setTitleColor(.cancelTextColor, for: .normal)
        button.layer.cornerRadius = 45
        return button
    }()
    
    let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("시작", for: .normal)
        button.backgroundColor = .startBGColor
        button.setTitleColor(.startTextColor, for: .normal)
        button.layer.cornerRadius = 45
        return button
    }()
    //
    let countdownLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 50, weight: .bold)
        label.textColor = .textColor
        label.isHidden = true
        return label
    }()
    
    lazy var trackLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.gray.cgColor
        layer.lineWidth = 15
        return layer
    }()
    
    lazy var barLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.green.cgColor
        layer.lineWidth = 15
        layer.strokeEnd = 0
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .bgColor
        setupUI()
        cofigureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        trackLayer.position = countdownLabel.center
        barLayer.position = countdownLabel.center
        
        let radius = (pickerView.bounds.width / 2) - 20
        
        let circularPath = UIBezierPath(arcCenter: .zero,
                                        radius: radius,
                                        startAngle: -90.degreesToRadians,
                                        endAngle: 270.degreesToRadians,
                                        clockwise: true)
        trackLayer.path = circularPath.cgPath
        barLayer.path = circularPath.cgPath
    }
    
    private func setupUI(){
        [timerLabel, pickerView,countdownLabel,cancelButton,startButton].forEach{
            self.addSubview($0)
        }
        [trackLayer,barLayer].forEach{
            self.layer.addSublayer($0)
        }
    }
    private func cofigureLayout(){
        timerLabel.snp.makeConstraints{ make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(10)
            make.leading.equalToSuperview().inset(20)
        }
        pickerView.snp.makeConstraints{ make in
            make.top.equalTo(timerLabel.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }
        cancelButton.snp.makeConstraints{ make in
            make.top.equalTo(pickerView.snp.bottom).offset(50)
            make.leading.equalToSuperview().inset(20)
            make.width.height.equalTo(90)
        }
        startButton.snp.makeConstraints{ make in
            make.top.equalTo(cancelButton)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(90)
        }
        
        countdownLabel.snp.makeConstraints{ make in
            make.center.equalTo(pickerView)
        }
        
        
    }
    
    func updateProgressBar(progress: CGFloat){
        barLayer.strokeEnd = progress
    }
    
    func startAnimation(duration: TimeInterval, initProgress: CGFloat){
        barLayer.removeAnimation(forKey: animationKey)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = initProgress
        animation.toValue = 1
        animation.duration = duration
        
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        barLayer.add(animation, forKey: animationKey)
        
    }
    
    func stopAnimation(){
        barLayer.removeAnimation(forKey: animationKey)
        barLayer.strokeEnd = 0
    }
}

extension Int{
    var degreesToRadians: CGFloat{
        return CGFloat(self) * .pi / 180
    }
}
