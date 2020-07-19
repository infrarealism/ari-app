import Foundation

struct User: Codable, Equatable {
    public var purchases = Set<Purchase>()
    public var rated = false
    public var created = Date()
    
    public func hash(into: inout Hasher) { }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        true
    }
}
