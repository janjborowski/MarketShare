import UIKit

protocol AssetListViewControllerFlowControllerProtocol: AnyObject {
    var sourceController: UIViewController! { get set }
    
    func goToDetails()
}

final class AssetListViewControllerFlowController: AssetListViewControllerFlowControllerProtocol {
    
    private let nextControllerFetcher: () -> AssetInfoViewController
    
    var sourceController: UIViewController!
    
    init(nextControllerFetcher: @escaping () -> AssetInfoViewController) {
        self.nextControllerFetcher = nextControllerFetcher
    }
    
    func goToDetails() {
        sourceController.navigationController?.pushViewController(nextControllerFetcher(), animated: true)
    }
    
}
