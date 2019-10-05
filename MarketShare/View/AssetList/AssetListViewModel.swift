import UIKit

protocol AssetListViewModelProtocol {
    
    var cells: [AssetListCellModel] { get }
    
    func configure(with: [AssetListCellModel])
    
}

final class AssetListViewModel: AssetListViewModelProtocol {
    
    var cells = [AssetListCellModel]()
    
    func configure(with cells: [AssetListCellModel]) {
        self.cells = cells
    }
    
}

extension AssetListViewModel {
  
    static var initialCellViewModels: [AssetListCellModel] {
        let stocksGroup: AssetListCellModel.CellType = .group([
            AssetListCellModel(name: "Global", color: UIColor.red, cellType: .single(.globalStocks)),
            AssetListCellModel(name: "Emerging market", color: UIColor.lightGray, cellType: .single(.emergingMarketStocks))
        ])

        return [
            AssetListCellModel(name: "Stocks", color: UIColor.purple, cellType: stocksGroup)
        ]
    }
    
}
