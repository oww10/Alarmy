
import UIKit
import SnapKit

final class StopWatchViewController: UIViewController{
    
    private let stopWatch = StopWatch()
    private var isPlay: Bool = false
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00.00"
        label.textColor = .white
        label.font = .monospacedDigitSystemFont(ofSize: 80, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.setTitle("시작", for: .normal)
        button.setTitleColor(.startTextColor, for: .normal)
        button.backgroundColor = .startBGColor
        button.layer.cornerRadius = 45
        button.addTarget(self, action: #selector(startPauseTime), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setConstraints()
    }
    
    private func configureUI() {
        view.backgroundColor = .black
        [timeLabel, startButton].forEach { view.addSubview($0) }
    }
    private func setConstraints() {
        timeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(320)
        }
        startButton.snp.makeConstraints{
            $0.top.equalTo(timeLabel.snp.bottom).offset(30)
            $0.trailing.equalToSuperview().inset(30)
            $0.width.height.equalTo(90)
        }
    }
}

extension StopWatchViewController {
    // "시작", "중단" 버튼 변경 함수
    private func changeButton(_ button: UIButton, backgroundColor: UIColor, title: String, titleColor: UIColor) {
        button.backgroundColor = backgroundColor
        button.setTitle(title, for: UIControl.State())
        button.setTitleColor(titleColor, for: UIControl.State())
     }
    // 시간 업데이트 함수
    private func updateTimer(_ stopWatch: StopWatch, label: UILabel) {
        stopWatch.counter = stopWatch.counter + 0.01
        var minutes: String = "\((Int)(stopWatch.counter / 60))"
        if (Int)(stopWatch.counter / 60) < 10 {
            minutes = "0\((Int)(stopWatch.counter / 60))"
        }
        var seconds: String = String(format: "%.2f", (stopWatch.counter.truncatingRemainder(dividingBy: 60)))
        if stopWatch.counter.truncatingRemainder(dividingBy: 60) < 10 {
            seconds = "0" + seconds
        }
        label.text = minutes + ":" + seconds
    }
    // timeLabel 업데이트
    @objc
    private func updateMainTimer() {
        updateTimer(stopWatch, label: timeLabel)
    }
    // 시작버튼 액션 함수
    @objc
    private func startPauseTime() {
        if !isPlay {
            stopWatch.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateMainTimer), userInfo: nil, repeats: true)
            RunLoop.current.add(stopWatch.timer, forMode: RunLoop.Mode.common)
            isPlay = true
            changeButton(startButton, backgroundColor: .stopBGColor, title: "중단", titleColor: .stopTextColor)
        } else {
            stopWatch.timer.invalidate()
            isPlay = false
            changeButton(startButton, backgroundColor: .startBGColor, title: "시작", titleColor: .startTextColor)
        }
    }
}
