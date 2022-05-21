import Foundation

public struct Local {
    private let directory: URL
    
    public init() {
        var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("projects")
        
        if !FileManager.default.fileExists(atPath: url.path) {
            var resources = URLResourceValues()
            resources.isExcludedFromBackup = true
            try? url.setResourceValues(resources)
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        }
        
        directory = url
    }
    
    public func size(header: Header) async -> Int? {
        await Task
            .detached(priority: .utility) {
                let url = directory.appendingPathComponent(header.id.uuidString)
                
                guard
                    FileManager.default.fileExists(atPath: url.path),
                    let data = try? Data(contentsOf: url),
                    !data.isEmpty
                else { return nil }
                
                return data.count
            }
            .value
    }
    
    public func delete(header: Header) {
        Task
            .detached(priority: .utility) {
                let url = directory.appendingPathComponent(header.id.uuidString)
                guard FileManager.default.fileExists(atPath: url.path) else { return }
                try? FileManager.default.removeItem(at: url)
            }
    }
    
    public func url(header: Header) -> URL {
        directory.appendingPathComponent(header.id.uuidString)
    }
}
