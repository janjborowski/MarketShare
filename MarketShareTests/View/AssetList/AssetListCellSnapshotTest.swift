import XCTest
import SnapshotTesting
@testable import MarketShare

class AssetListCellSnapshotTest: XCTestCase {

    private var sut: AssetListCell!
    
    override func setUp() {
        super.setUp()
        record = false
        
        sut = AssetListCell()
    }

    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }

    func testLayout() {
        assertSnapshot(matching: sut, as: .image)
    }

}
