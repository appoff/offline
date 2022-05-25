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
        if let created = created {
            let days = Calendar.current.dateComponents([.day], from: created, to: .init()).day!
            return days > 1
        } else {
            created = .init()
        }
        return false
    }
    
    static var created: Date? {
        get { self[.created] as? Date }
        set { self[.created] = newValue }
    }
    
    private static subscript(_ key: Key) -> Any? {
        get { UserDefaults.standard.object(forKey: key.rawValue) }
        set { UserDefaults.standard.setValue(newValue, forKey: key.rawValue) }
    }
    
    private init() { }
}
