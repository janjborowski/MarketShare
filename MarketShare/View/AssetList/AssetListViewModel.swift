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
            AssetListCellModel(name: "Emerging markets", color: UIColor.lightGray, cellType: .single(.emergingMarketStocks)),
            AssetListCellModel(name: "Frontier markets", color: UIColor.darkGray, cellType: .single(.frontierMarketStocks))
        ])
        
        let cryptoGroup: AssetListCellModel.CellType = .group([
            AssetListCellModel(name: "All coins", color: UIColor.orange, cellType: .single(.crypto)),
            AssetListCellModel(name: "Coins without Bitcoin", color: UIColor.brown, cellType: .single(.cryptoNoBitcoin))
        ])

        return [
            AssetListCellModel(name: "Stocks", color: UIColor.purple, cellType: stocksGroup),
            AssetListCellModel(name: "Cryptocurrencies", color: UIColor.orange, cellType: cryptoGroup)
        ]
    }
    
}
