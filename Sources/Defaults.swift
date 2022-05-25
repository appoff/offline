import Foundation

public struct Defaults {
    private enum Key: String {
        case
        created,
        cloud
    }
    
    public static var cloud: Bool {
        get { self[.cloud] as? Bool ?? false }
        set { self[.cloud] = newValue }
    }
    
    public static var rate: Bool {
        created
            .map {
                let days = Calendar.current.dateComponents([.day], from: $0, to: .init()).day!
                return days > 1
            }
        ?? false
    }
    
    private static var created: Date? {
        get { self[.created] as? Date }
        set { self[.created] = newValue }
    }
    
    private static subscript(_ key: Key) -> Any? {
        get { UserDefaults.standard.object(forKey: key.rawValue) }
        set { UserDefaults.standard.setValue(newValue, forKey: key.rawValue) }
    }
    
    public static func start() {
        if created == nil {
            created = .init()
        }
    }
    
    private init() { }
}
