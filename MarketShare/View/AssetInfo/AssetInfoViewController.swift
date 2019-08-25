import UIKit

final class AssetInfoViewController: UIViewController {

    private let viewModel: AssetInfoViewModelProtocol
    
    private let activityIndicator = UIActivityIndicatorView(style: .gray)
    private let errorLabel = UILabel()
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let cellReuseIdentifier = "reuseIdentifier"
    
    init(viewModel: AssetInfoViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        setUpObservers()
        viewModel.downloadSummaries()
    }
    
    private func setUpViews() {
        setUpSelf()
        setUpTableView()
        setUpActivityIndicator()
        setUpErrorLabel()
        setUpConstaints()
    }
    
    private func setUpSelf() {
        navigationController?.navigationBar.prefersLargeTitles = false
        view.backgroundColor = UIColor.white
    }
    
    private func setUpTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
    }
    
    private func setUpActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(activityIndicator)
    }
    
    private func setUpErrorLabel() {
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.text = "data_cannot_be_fetched".localized
        errorLabel.font = UIFont.systemFont(ofSize: 20)
        
        view.addSubview(errorLabel)
    }
    
    private func setUpConstaints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setUpObservers() {
        viewModel.state.observeNow { [weak self] (state) in
            DispatchQueue.main.async { [weak self] in
                self?.update(state: state)
            }
        }
    }
    
    private func update(state: AssetInfoViewModelState) {
        switch state {
        case .loading:
            configureForLoading()
        case .fetched:
            configureForFetched()
        case .error:
            configureForError()
        }
    }
    
    private func configureForLoading() {
        activityIndicator.startAnimating()
        
        tableView.isHidden = true
        errorLabel.isHidden = true
    }
    
    private func configureForFetched() {
        activityIndicator.stopAnimating()
        
        tableView.reloadData()
        tableView.isHidden = false
        errorLabel.isHidden = true
    }
    
    private func configureForError() {
        activityIndicator.stopAnimating()
        
        tableView.isHidden = true
        errorLabel.isHidden = false
    }

}

extension AssetInfoViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if let reusedCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) {
            cell = reusedCell
        } else {
            cell = UITableViewCell(style: .value1, reuseIdentifier: cellReuseIdentifier)
        }
        
        cell.selectionStyle = .none
        
        let entry = viewModel.cellViewModels[indexPath.row]
        cell.textLabel?.text = entry.name
        cell.detailTextLabel?.text = entry.value
        
        return cell
    }
    
    
}
