import UIKit

struct AssetListCellModel {
    
    let name: String
    let color: UIColor
    let cellType: CellType
 
    enum CellType {
        
        case single(Asset)
        case group([AssetListCellModel])
        
    }
    
}
