import Foundation

public struct Local {
    private let directory: URL
    
    public init() {
        var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("maps")
        
        if !FileManager.default.fileExists(atPath: url.path) {
            var resources = URLResourceValues()
            resources.isExcludedFromBackup = true
            try? url.setResourceValues(resources)
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        }
        
        directory = url
    }
    
    public func load(map: Map) -> Tiles? {
        let url = directory.appendingPathComponent(map.id.uuidString)
        
        guard
            FileManager.default.fileExists(atPath: url.path),
            var data = try? Data(contentsOf: url),
            !data.isEmpty
        else { return nil }
        
        return .init(data: &data)
    }
    
    func save(map: Map, tiles: Tiles) throws {
        try tiles
            .data
            .write(to: directory.appendingPathComponent(map.id.uuidString), options: .atomic)
    }
}
