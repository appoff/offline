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
                    .adding(UInt16(z.value.count))
                    .adding(z
                        .value
                        .flatMap { x in
                            Data()
                                .adding(x.key)
                                .adding(UInt16(x.value.count))
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
        items = (0 ..< .init(data.number() as UInt8))
            .reduce(into: [:]) { z, _ in
                z[data.number()] = (0 ..< .init(data.number() as UInt16))
                    .reduce(into: [:]) { x, _ in
                        x[data.number()] = (0 ..< .init(data.number() as UInt16))
                            .reduce(into: [:]) { y, _ in
                                y[data.number()] = data.unwrap(size: UInt32.self)
                            }
                    }
            }
    }
    
    init(items: [UInt8 : [UInt32 : [UInt32 : Data]]]) {
        self.items = items
    }
    
    public subscript(x: Int, y: Int, z: Int) -> Data? {
        items[.init(z)]?[.init(x)]?[.init(y)]
    }
}
