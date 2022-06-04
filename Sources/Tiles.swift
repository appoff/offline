#if os(iOS) || os(macOS)
import Foundation
import Archivable

struct Tiles: Storable {
    private let items: [UInt8 : [UInt32 : [UInt32 : UInt32]]]
    
    var data: Data {
        .init()
        .adding(UInt8(items.count))
        .adding(items
            .flatMap { z in
                Data()
                    .adding(z.key)
                    .adding(UInt8(z.value.count))
                    .adding(z
                        .value
                        .flatMap { x in
                            Data()
                                .adding(x.key)
                                .adding(UInt8(x.value.count))
                                .adding(x
                                    .value
                                    .flatMap { y in
                                        Data()
                                            .adding(y.key)
                                            .adding(y.value)
                                    })
                        })
            })
    }
    
    init(data: inout Data) {
        items = (0 ..< .init(data.number() as UInt8))
            .reduce(into: [:]) { z, _ in
                z[data.number()] = (0 ..< .init(data.number() as UInt8))
                    .reduce(into: [:]) { x, _ in
                        x[data.number()] = (0 ..< .init(data.number() as UInt8))
                            .reduce(into: [:]) { y, _ in
                                y[data.number()] = data.number()
                            }
                    }
            }
    }
    
    init(items: [UInt8 : [UInt32 : [UInt32 : UInt32]]]) {
        self.items = items
    }
    
    subscript(x: Int, y: Int, z: Int) -> UInt32? {
        items[.init(z)]?[.init(x)]?[.init(y)]
    }
}
#endif
