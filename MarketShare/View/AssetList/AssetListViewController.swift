import UIKit

final class AssetListViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        
        title = "Assets"
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    private func setUpTableView() {
        tableView.register(AssetListCell.self, forCellReuseIdentifier: NSStringFromClass(AssetListCell.classForCoder()))
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(AssetListCell.classForCoder()))!
        
        return cell
    }
    
}
