
import UIKit
import SnapKit

class WorldClockViewController: UIViewController {
    
    let coreDataManager = CoreDataManager.shared
    var selectedClockData: [(cityName: String, countryName: String, timeZoneID: String)] = []
    
    private let worldClockLabel: UILabel = {
        let label = UILabel()
        label.text = "세계 시간"
        label.font = .systemFont(ofSize: 36, weight: .heavy)
        label.textColor = .textColor
        return label
    }()
    private lazy var worldClockTV: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .bgColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WorldClockCell.self, forCellReuseIdentifier: WorldClockCell.id)
        tableView.separatorColor = UIColor(red: 92/255.0, green: 92/255.0, blue: 92/255.0, alpha: 0.5)
        tableView.rowHeight = 80
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setConstraints()
        setupNavigationBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadWorldData()
    }
    
    private func configureUI() {
        view.backgroundColor = .bgColor
        [worldClockLabel, worldClockTV].forEach { view.addSubview($0) }
    }
    
    private func setConstraints() {
        worldClockLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        worldClockTV.snp.makeConstraints {
            $0.top.equalTo(worldClockLabel.snp.bottom).offset(20)
            //$0.top.equalTo(worldClockLabel.snp.bottom)
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
        //self.navigationItem.leftBarButtonItem?.tintColor = .selectBGColor
    }
}
// 데이터 불러오기
extension WorldClockViewController {
    private func loadWorldData() {
        self.selectedClockData = coreDataManager.loadWorldData()
        self.worldClockTV.reloadData()
    }
}

// 내비게이션바 버튼 실행 함수
extension WorldClockViewController {
    @objc
    private func didTappedAdd() {
        let citySearchViewC = CitySearchViewController()
        citySearchViewC.delegate = self

        let citySearchVC = UINavigationController(rootViewController: citySearchViewC)
        citySearchVC.modalPresentationStyle = .pageSheet
        self.present(citySearchVC, animated: true, completion: nil)
    }
    @objc
    private func didTappedDeleteAll() {
        coreDataManager.deleteAllWorldData()
        loadWorldData()
    }
}
// Delegate 채택 및 저장
extension WorldClockViewController: CitySearchDelegate {
    func didSelectCity(city data: (cityName: String, countryName: String, timeZoneID: String)) {
        coreDataManager.saveWorldData(city: data)
        loadWorldData()
    }
}

// 테이블뷰 델리게이트, 데이터소스
extension WorldClockViewController: UITableViewDelegate, UITableViewDataSource {
    // 테이블뷰 셀 크기
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedClockData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: WorldClockCell.id, for: indexPath) as? WorldClockCell else {
            return UITableViewCell()
        }
        let cityData = selectedClockData[indexPath.row]
        cell.selectionStyle = .none
        cell.configure(with: cityData)
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let delete = selectedClockData[indexPath.row]
            coreDataManager.deleteWorldData(with: delete.timeZoneID)
            selectedClockData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
