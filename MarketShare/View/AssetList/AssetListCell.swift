import UIKit

final class AssetListCell: UITableViewCell {
    
    private let roundedContainerHeight : CGFloat = 66
    
    private let roundedContainer = UIView()
    private let mainLabel = UILabel()
    
    static var reuseIdentifier: String {
        return NSStringFromClass(AssetListCell.classForCoder())
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        setUpSelf()
        setUpRoundedContainer()
        setUpMainLabel()
        
        roundedContainer.disableAutoresizingMasks()
        setUpConstraints()
    }
    
    private func setUpSelf() {
        selectionStyle = .none
    }
    
    private func setUpRoundedContainer() {
        roundedContainer.layer.cornerRadius = Styling.cornerRadius
        roundedContainer.layer.masksToBounds = true
        roundedContainer.layer.rasterizationScale = UIScreen.main.scale
        roundedContainer.layer.shouldRasterize = true
        roundedContainer.backgroundColor = UIColor.purple
        
        contentView.addSubview(roundedContainer)
    }
    
    private func setUpMainLabel() {
        mainLabel.textColor = UIColor.white
        mainLabel.text = "Stocks"
        
        roundedContainer.addSubview(mainLabel)
    }
    
    private func setUpConstraints() {
        let roundedContainerHeightConstraint =
            roundedContainer.heightAnchor.constraint(equalToConstant: roundedContainerHeight)
        roundedContainerHeightConstraint.priority = .required - 1
        
        NSLayoutConstraint.activate([
            roundedContainer.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            roundedContainer.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            roundedContainer.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            roundedContainer.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            roundedContainerHeightConstraint,
            
            mainLabel.centerYAnchor.constraint(equalTo: roundedContainer.layoutMarginsGuide.centerYAnchor),
            mainLabel.leadingAnchor.constraint(equalTo: roundedContainer.layoutMarginsGuide.leadingAnchor),
            mainLabel.trailingAnchor.constraint(equalTo: roundedContainer.layoutMarginsGuide.trailingAnchor),
        ])
    }

}

extension AssetListCell {
    
    func configure(with model: AssetListCellModel) {
        mainLabel.text = model.name
        roundedContainer.backgroundColor = model.color
    }
    
}
