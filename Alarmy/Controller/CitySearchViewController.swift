import UIKit
import SnapKit

class CitySearchViewController: UIViewController {
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.gray]
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "도시를 입력하세요", attributes: attributes)
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
        self.navigationItem.title = "도시 선택"
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
extension CitySearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true)
    }
}

extension CitySearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: CitySearchCell.id, for: indexPath) as? CitySearchCell else {
            return UITableViewCell()
        }
        cell.configure()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true)
    }
    
    
}
