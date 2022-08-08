import Foundation

extension Array where Element == Project {
    public func filtered(search: String) -> Self {
        { string in
            string.isEmpty
            ? self
            : { components in
                filter {
                    $0.contains(tokens: components)
                }
            } (string.components(separatedBy: " "))
        } (search.trimmingCharacters(in: .whitespacesAndNewlines))
    }
}
