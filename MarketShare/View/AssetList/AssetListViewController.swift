import UIKit

final class AssetListViewController: UITableViewController {
    
    private let viewModel: AssetListViewModelProtocol
    private let flowController: AssetListViewControllerFlowControllerProtocol
    
    init(viewModel: AssetListViewModelProtocol, flowController: AssetListViewControllerFlowControllerProtocol) {
        self.viewModel = viewModel
        self.flowController = flowController
        super.init(nibName: nil, bundle: nil)
        flowController.sourceController = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        preconditionFailure()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellModel = viewModel.cells[indexPath.row]
        flowController.goToDetails(of: cellModel)
    }
    
    func configure(cells: [AssetListCellModel], name: String) {
        title = name
        viewModel.configure(with: cells)
        tableView.reloadData()
    }
    
}
