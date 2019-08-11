import UIKit

final class AssetListViewController: UITableViewController {
    
    private let viewModel: AssetListViewModelProtocol
    
    init(viewModel: AssetListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        preconditionFailure()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        
        title = "Assets"
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    private func setUpTableView() {
        tableView.register(AssetListCell.self, forCellReuseIdentifier: AssetListCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AssetListCell.reuseIdentifier) as? AssetListCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.cells[indexPath.row])
        return cell
    }
    
}
