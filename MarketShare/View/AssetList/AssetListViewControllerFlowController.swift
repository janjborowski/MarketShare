import UIKit

protocol AssetListViewControllerFlowControllerProtocol: AnyObject {
    var sourceController: UIViewController! { get set }
    
    func goToDetails(of cellModel: AssetListCellModel)
}

final class AssetListViewControllerFlowController: AssetListViewControllerFlowControllerProtocol {
    
    private let infoViewControllerFetcher: () -> AssetInfoViewController
    private let listViewControllerFetcher: () -> AssetListViewController
    
    var sourceController: UIViewController!
    
    init(infoViewControllerFetcher: @escaping () -> AssetInfoViewController, listViewControllerFetcher: @escaping () -> AssetListViewController) {
        self.infoViewControllerFetcher = infoViewControllerFetcher
        self.listViewControllerFetcher = listViewControllerFetcher
    }
    
    func goToDetails(of cellModel: AssetListCellModel) {
        switch cellModel.cellType {
        case .single(let asset):
            let infoViewController = infoViewControllerFetcher()
            infoViewController.configure(asset)
            sourceController.navigationController?.pushViewController(infoViewController, animated: true)
        case .group(let cells):
            let listViewController = listViewControllerFetcher()
            listViewController.configure(cells: cells, name: cellModel.name)
            sourceController.navigationController?.pushViewController(listViewController, animated: true)
        }
    }
    
}
