import Foundation
import Archivable

public struct Tiles: Storable {
    private let items: [UInt8 : [UInt32 : [UInt32 : Data]]]
    
    public var data: Data {
        .init()
        .adding(UInt8(items.count))
        .adding(items
            .flatMap { z in
                Data()
                    .adding(z.key)
                    .adding(UINt)
                    .adding(z
                        .value
                        .flatMap { x in
                            Data()
                                .adding(x.key)
                                .adding(x
                                    .value
                                    .flatMap { y in
                                        Data()
                                            .adding(y.key)
                                            .wrapping(size: UInt32.self, data: y.value)
                                    })
                        })
            })
    }
    
    public init(data: inout Data) {
        items = (0 ..< .init(data.number() as UInt32)).reduce(into: [:]) {
            print($1)
            $0[data.number()] = $1
        }
    }
    
    init(items: [UInt8 : [UInt32 : [UInt32 : Data]]]) {
        self.items = items
    }
    
    public subscript(x: Int, y: Int, z: Int) -> Data? {
        items[.init(x)]?[.init(y)]?[.init(z)]
    }
}
