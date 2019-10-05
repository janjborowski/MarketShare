import UIKit
import Charts

final class AssetInfoViewController: UIViewController {

    private let viewModel: AssetInfoViewModelProtocol
    
    private let activityIndicator = UIActivityIndicatorView(style: .gray)
    private let errorLabel = UILabel()
    
    private let mainContainer = UIStackView()
    private let pieChartView = PieChartView()
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
    }
    
    private func setUpViews() {
        setUpSelf()
        setUpMainContainer()
        setUpChart()
        setUpTableView()
        setUpActivityIndicator()
        setUpErrorLabel()
        
        setUpConstaints()
    }
    
    private func setUpSelf() {
        navigationItem.largeTitleDisplayMode = .never
        
        view.backgroundColor = UIColor.white
    }
    
    private func setUpMainContainer() {
        mainContainer.translatesAutoresizingMaskIntoConstraints = false
        mainContainer.axis = .vertical
        mainContainer.distribution = .fill
        mainContainer.spacing = 0
        
        view.addSubview(mainContainer)
    }
    
    private func setUpChart() {
        pieChartView.translatesAutoresizingMaskIntoConstraints = false
        pieChartView.chartDescription?.enabled = false
        pieChartView.legend.enabled = false
        
        mainContainer.addArrangedSubview(pieChartView)
    }
    
    private func setUpTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        mainContainer.addArrangedSubview(tableView)
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
            mainContainer.topAnchor.constraint(equalTo: view.topAnchor),
            mainContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            pieChartView.heightAnchor.constraint(equalToConstant: 350),
            
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
        
        mainContainer.isHidden = true
        errorLabel.isHidden = true
    }
    
    private func configureForFetched() {
        activityIndicator.stopAnimating()
        
        pieChartView.data = createPieChartData()
        tableView.reloadData()
        mainContainer.isHidden = false
        errorLabel.isHidden = true
    }
    
    private func createPieChartData() -> PieChartData {
        let set = PieChartDataSet(entries: viewModel.pieChartEntries, label: nil)
        set.drawIconsEnabled = false
        set.drawValuesEnabled = false
        set.sliceSpace = 2
        
        set.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
        
        let data = PieChartData(dataSet: set)
        data.setValueFont(.systemFont(ofSize: 12, weight: .light))
        data.setValueTextColor(.black)
        
        return data
    }
    
    private func configureForError() {
        activityIndicator.stopAnimating()
        
        mainContainer.isHidden = true
        errorLabel.isHidden = false
    }
    
    func configure(_ asset: Asset) {
        viewModel.downloadSummaries(of: asset)
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
