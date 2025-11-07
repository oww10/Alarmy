// 알람 목록
import UIKit
import SnapKit
import UserNotifications


class AlarmViewController: UIViewController, EditViewControllerDelegate {
    
    private let mainLabel = UILabel()
    private let tableView = UITableView()
    private let coreDataManager = CoreDataManager.shared
    private var alarmInfo: [Alarm] = []
    
    
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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "전체삭제", style: .plain, target: self, action: #selector(deleteTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(addTapped))
        
        let ap = UINavigationBarAppearance()
        ap.configureWithOpaqueBackground()
        ap.backgroundColor = .systemBackground
        ap.backgroundColor = .black
        navigationItem.standardAppearance = ap
        navigationItem.scrollEdgeAppearance = ap
        
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
        self.tableView.reloadData()
    }
    
    // 스와이프 삭제
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) {
            [weak self](action, view, completion) in
            guard let self = self else { return }
            let info = self.alarmInfo[indexPath.row]
            let id = info.objectID.uriRepresentation().absoluteString
            AlarmNotification.shared.cancelAlarm(id: id)
            
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
    
    // 셀 클릭
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedAlarm = alarmInfo[indexPath.row]
        let editVC = EditViewController(alarm: selectedAlarm)
        editVC.delegate = self
        
        let nav = UINavigationController(rootViewController: editVC)
        nav.modalPresentationStyle = .pageSheet
        
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.preferredCornerRadius = 30
            sheet.prefersGrabberVisible = true
        }
        
        present(nav, animated: true)
        
    }
    


    
    
    // 전체 삭제
    @objc private func deleteTapped() {
        guard !alarmInfo.isEmpty else { return }
        
        let alert = UIAlertController(title: "전체 삭제", message: "모든 항목을 삭제할까요?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive) {[weak self] _ in
            guard let self = self else { return }
            
            let center = UNUserNotificationCenter.current()
            center.removeAllPendingNotificationRequests()   // 대기 중인 알림 전체 삭제
            center.removeAllDeliveredNotifications()        // 이미 울린 알림도 삭제
            
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
        
        cell.selectionStyle = .none
        cell.backgroundColor = .black
        let alarm = alarmInfo[indexPath.row]
        cell.configure(with: alarm)
        
        // 초기 색상
        cell.timeLabel.textColor = alarm.isOn
             ? .white
             : UIColor(red: 115/255.0, green: 115/255.0, blue: 115/255.0, alpha: 1.0)

        // 토글 스위치
        cell.switchChanged = { [weak self, weak tableView, weak cell] isOn in
            guard let self,
                  let tableView,
                  let cell,
                  let ip = tableView.indexPath(for: cell)
            else { return }
            
            let changedAlarm = self.alarmInfo[ip.row]
            changedAlarm.isOn = isOn
            self.coreDataManager.saveContext()
            let alarmObj = self.alarmInfo[ip.row]
            let id = alarmObj.objectID.uriRepresentation().absoluteString
            
            if isOn {
                AlarmNotification.shared.cancelAlarm(id: id)
                if let date = alarmObj.date {
                    AlarmNotification.shared.alarmNoti(date: date, id: id)
                    cell.timeLabel.textColor = .white
                }
            } else {
                AlarmNotification.shared.cancelAlarm(id: id)
                UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [id])
                cell.timeLabel.textColor = UIColor(red: 115/255.0, green: 115/255.0, blue: 115/255.0, alpha: 1.0)
            }
        }
        
        return cell
    }
    
    
}
