// 알람 목록
import UIKit
import SnapKit


class AlarmViewController: UIViewController{
    
    private let mainLabel = UILabel()
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureUI()
    }
    
    private func configureUI() {
        [mainLabel, tableView].forEach { view.addSubview($0) }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "전체삭제",
            style: .plain,
            target: self,
            action: #selector(deleteTapped)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "추가",
            style: .plain,
            target: self,
            action: #selector(addTapped)
        )
        
        
        let ap = UINavigationBarAppearance()
        ap.configureWithOpaqueBackground()
        ap.backgroundColor = .systemBackground
        
        mainLabel.text = "알람"
        mainLabel.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        mainLabel.textColor = .white
        mainLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(30)
            $0.top.equalToSuperview().inset(140)
        }
    }
    
    @objc private func deleteTapped() {
        
    }
    
    @objc private func addTapped() {
        let modalVC = EditViewController()
        let nav = UINavigationController(rootViewController: modalVC)
        nav.modalPresentationStyle = .pageSheet
        
        if let sheet = modalVC.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.preferredCornerRadius = 30
            sheet.prefersGrabberVisible = true
        }
        
        present(nav, animated: true)
    }
    
}
