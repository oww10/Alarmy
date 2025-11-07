import UIKit
import SnapKit

class CitySearchViewController: UIViewController {
    
    weak var delegate: CitySearchDelegate?
    
    let allCities: [(cityName: String, countryName: String, timeZoneID: String)] = WorldClockModel.shared.worldClockData()
    var filterdCities: [(cityName: String, countryName: String, timeZoneID: String)] = []
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.gray]
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "도시(나라)를 입력하세요", attributes: attributes)
        searchBar.backgroundImage = UIImage()
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.leftView?.tintColor = .gray
        searchBar.delegate = self
        return searchBar
    }()
    private lazy var cityTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .bgColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CitySearchCell.self, forCellReuseIdentifier: CitySearchCell.id)
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
        filterdCities = allCities
    }
    
    private func configureUI() {
        view.backgroundColor = .bgColor
        [searchBar, cityTableView].forEach { view.addSubview($0) }
    }
    private func setConstraints() {
        searchBar.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        cityTableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    // 내비게이션바 아이템 추가
    private func setupNavigationBar() {
        self.navigationItem.title = "도시(나라) 선택"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButton))
        self.navigationItem.rightBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem?.tintColor = .selectBGColor
    }
    
    @objc
    private func cancelButton() {
        self.dismiss(animated: true)
    }
}
// 검색어에 따른 필러링
extension CitySearchViewController {
    private func filterCities(with searchText: String) {
        if searchText.isEmpty {
            filterdCities = allCities
        } else {
            filterdCities = allCities.filter { city in
                let isCityMatch = city.cityName.localizedCaseInsensitiveContains(searchText)
                let isCountryMatch = city.countryName.localizedCaseInsensitiveContains(searchText)
                return isCityMatch || isCountryMatch
            }
        }
        cityTableView.reloadData()
    }
}


// 서치바 관련 함수들
extension CitySearchViewController: UISearchBarDelegate {
    // 검색어 바뀔 때마다 자동 호출 함수
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterCities(with: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension CitySearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterdCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: CitySearchCell.id, for: indexPath) as? CitySearchCell else {
            return UITableViewCell()
        }
        let cityData = self.filterdCities[indexPath.row]
        cell.configure(with: cityData)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCity = self.filterdCities[indexPath.row]
        delegate?.didSelectCity(city: selectedCity)
        self.dismiss(animated: true)
    }
    
}
