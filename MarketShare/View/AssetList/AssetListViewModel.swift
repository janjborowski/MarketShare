import UIKit

protocol AssetListViewModelProtocol {
    
    var cells: [AssetListCellModel] { get }
    
}

final class AssetListViewModel: AssetListViewModelProtocol {
    
    var cells: [AssetListCellModel] {
        return [
            AssetListCellModel(name: "Stocks", color: UIColor.purple)
        ]
    }
    
}
