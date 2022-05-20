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
    
    public func load(map: Map) async -> Data? {
        await Task
            .detached(priority: .utility) {
                let url = directory.appendingPathComponent(map.id.uuidString)
                
                guard
                    FileManager.default.fileExists(atPath: url.path),
                    let data = try? Data(contentsOf: url),
                    !data.isEmpty
                else { return nil }
                
                return data
            }
            .value
    }
    
    public func delete(map: Map) {
        Task
            .detached(priority: .utility) {
                let url = directory.appendingPathComponent(map.id.uuidString)
                guard FileManager.default.fileExists(atPath: url.path) else { return }
                try? FileManager.default.removeItem(at: url)
            }
    }
    
    func url(map: Map) -> URL {
        directory.appendingPathComponent(map.id.uuidString)
    }
}
