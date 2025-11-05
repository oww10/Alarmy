// 알람 목록
import UIKit
import SnapKit


class AlarmViewController: UIViewController, EditViewControllerDelegate {
    
    private let mainLabel = UILabel()
    private let tableView = UITableView()
    private var alarmInfo: [Alarm] = []
    private let coreDataManager = CoreDataManager.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureUI()
        configureTable()
        alarmInfo = coreDataManager.readData()
    }
    

    func didUpdateAlarm() { reloadAlarm() }
    
    
    private func configureUI() {
        view.addSubview(mainLabel)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "전체삭제",
            style: .plain,
            target: self,
            action: #selector(deleteTapped(_:))
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
    
    
    /* ----- 테이블 ----- */
    private func configureTable() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AlarmTableViewCell.self, forCellReuseIdentifier: AlarmTableViewCell.identifier)
        
        tableView.separatorColor = UIColor(red: 92/255.0, green: 92/255.0, blue: 92/255.0, alpha: 0.5)
        tableView.backgroundColor = .black
        tableView.rowHeight = 80
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(mainLabel.snp.bottom).offset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
    private func reloadAlarm() {
        alarmInfo = coreDataManager.readData()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
           let deleteAction = UIContextualAction(style: .destructive, title: nil) {
               [weak self](action, view, completion) in
               guard let self = self else { return }
               let info = self.alarmInfo[indexPath.row]
               
               CoreDataManager.shared.deleteData(alarm: info)
               
               self.alarmInfo.remove(at: indexPath.row)
               tableView.deleteRows(at: [indexPath], with: .automatic)
               completion(true)
           }
           
           deleteAction.image = UIImage(systemName: "trash")
           let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
           configuration.performsFirstActionWithFullSwipe = true
           return configuration
       }
    
    
    @objc private func deleteTapped(_ sender: UIButton) {
        guard !alarmInfo.isEmpty else { return }
        
        let alert = UIAlertController(title: "전체 삭제", message: "모든 항목을 삭제할까요?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive) {[weak self] _ in
            guard let self = self else { return }
            self.coreDataManager.deleteAllData()
            self.alarmInfo.removeAll()
            self.tableView.reloadData()
        })
        present(alert, animated: true)
    }
    
    
    @objc private func addTapped() {
        let modalVC = EditViewController()
        modalVC.delegate = self
        
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



extension AlarmViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlarmTableViewCell.identifier, for: indexPath) as? AlarmTableViewCell else { return .init() }
        
        cell.backgroundColor = .black
        cell.configure(with: alarmInfo[indexPath.row])
        
        return cell
    }
    
    
}
