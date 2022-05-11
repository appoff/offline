import Foundation
import Archivable

struct Map: Storable {
    let item: Item
    let tiles: Data
    
    public var data: Data {
        .init()
    }
    
    public init(data: inout Data) {
        item = .offloaded
        tiles = .init()
    }
    
    init(item: Item, tiles: Tiles) {
        self.item = item
        self.tiles = tiles.data
    }
}
