
import UIKit
import SnapKit

class WorldClockViewController: UIViewController {
    
    private let worldClockLabel: UILabel = {
        let label = UILabel()
        label.text = "세계 시간"
        label.font = .systemFont(ofSize: 44, weight: .heavy)
        label.textColor = .textColor
        return label
    }()
    private lazy var worldClockTV: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .bgColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WorldClockCell.self, forCellReuseIdentifier: WorldClockCell.id)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setConstraints()
        setupNavigationBar()
    }
    
    private func configureUI() {
        view.backgroundColor = .bgColor
        [worldClockLabel, worldClockTV].forEach { view.addSubview($0) }
    }
    
    private func setConstraints() {
        worldClockLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.leading.equalToSuperview().inset(20)
        }
        worldClockTV.snp.makeConstraints {
            $0.top.equalTo(worldClockLabel.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    // 내비게이션바 아이템 추가
    private func setupNavigationBar() {
        let addButton = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(didTappedAdd))
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.rightBarButtonItem?.tintColor = .selectBGColor
        
        let deleteAllButton = UIBarButtonItem(title: "전체 삭제", style: .plain, target: self, action: #selector(didTappedDeleteAll))
        self.navigationItem.leftBarButtonItem = deleteAllButton
        self.navigationItem.leftBarButtonItem?.tintColor = .selectBGColor
    }
}
// 내비게이션바 버튼 실행 함수
extension WorldClockViewController {
    @objc
    private func didTappedAdd() {

        let citySearchVC = UINavigationController(rootViewController: CitySearchViewController())
        citySearchVC.modalPresentationStyle = .pageSheet
        self.present(citySearchVC, animated: true, completion: nil)
    }
    @objc
    private func didTappedDeleteAll() {
        print("전체삭제버튼 눌림")
    }
}
// 테이블뷰 델리게이트, 데이터소스
extension WorldClockViewController: UITableViewDelegate, UITableViewDataSource {
    // 테이블뷰 셀 크기
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: WorldClockCell.id, for: indexPath) as? WorldClockCell else {
            return UITableViewCell()
        }
        cell.configure()
        return cell
    }
}
