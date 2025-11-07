
import UIKit
import SnapKit

final class StopWatchViewController: UIViewController{
    
    private let stopWatch = StopWatch()
    private var isPlay: Bool = false
    private var backgroundDate: Date?
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00.00"
        label.textColor = .white
        label.font = .monospacedDigitSystemFont(ofSize: 80, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    lazy var startButton: UIButton = {
        let button = UIButton()
        button.setTitle("시작", for: .normal)
        button.setTitleColor(.startTextColor, for: .normal)
        button.backgroundColor = .startBGColor
        button.layer.cornerRadius = 45
        button.addTarget(self, action: #selector(startPauseTime), for: .touchUpInside)
        return button
    }()
    lazy var resetButton: UIButton = {
        let button = UIButton()
        button.setTitle("재설정", for: .normal)
        button.setTitleColor(.cancelTextColor, for: .normal)
        button.backgroundColor = .cancelBGColor
        button.layer.cornerRadius = 45
        button.addTarget(self, action: #selector(resetTime), for: .touchUpInside)
        return button
    }()
    private let formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setConstraints()
        sceneState()
    }
    // Observer 해제
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // 백그라운드로 진입할 때 호출
    private func sceneState() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(moveToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(moveToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    @objc
    private func moveToBackground() {
        if isPlay {
            backgroundDate = Date()
        }
    }
    @objc
    private func moveToForeground() {
        guard isPlay, let storedBackgroundData = backgroundDate else { return }
        let foregroundDate = Date()
        let timeElapsed = foregroundDate.timeIntervalSince(storedBackgroundData)
        stopWatch.counter += timeElapsed
        updateMainTimer()
        backgroundDate = nil
    }
    
    private func configureUI() {
        view.backgroundColor = .bgColor
        [timeLabel, startButton, resetButton].forEach { view.addSubview($0) }
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
        resetButton.snp.makeConstraints{
            $0.top.equalTo(timeLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(30)
            $0.width.height.equalTo(90)
        }
    }
}

extension StopWatchViewController {
    // "시작", "중단" 버튼 UI 변경 함수
    private func changeButton(_ button: UIButton, backgroundColor: UIColor, title: String, titleColor: UIColor) {
        button.backgroundColor = backgroundColor
        button.setTitle(title, for: UIControl.State())
        button.setTitleColor(titleColor, for: UIControl.State())
     }
    // 시간 업데이트 함수
    private func updateTimer(_ stopWatch: StopWatch, label: UILabel) {
        stopWatch.counter += 0.01
        let withoutMilliseconds = Int(stopWatch.counter)
        let minutesSeconds = formatter.string(from: TimeInterval(withoutMilliseconds)) ?? "00:00"
        let milliseconds = String(format: "%.2f", stopWatch.counter.truncatingRemainder(dividingBy: 1)).dropFirst()
        
        timeLabel.text = minutesSeconds + milliseconds
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
            stopWatch.timer = Timer.scheduledTimer(
                timeInterval: 0.01, target: self, selector: #selector(updateMainTimer), userInfo: nil, repeats: true)
            RunLoop.current.add(stopWatch.timer, forMode: RunLoop.Mode.common)
            isPlay = true
            changeButton(startButton, backgroundColor: .stopBGColor, title: "중단", titleColor: .stopTextColor)
        } else {
            stopWatch.timer.invalidate()
            isPlay = false
            changeButton(startButton, backgroundColor: .startBGColor, title: "시작", titleColor: .startTextColor)
        }
    }
    // 재설정버튼 액션 함수
    @objc
    private func resetTime() {
        stopWatch.timer.invalidate()
        stopWatch.counter = 0.0
        timeLabel.text = "00:00.00"
    }
}
