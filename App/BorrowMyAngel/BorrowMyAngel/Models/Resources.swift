import Foundation

struct ResourceType {
    let name: String
    var resources: [ResourceItem]
}
struct ResourceItem {
    let title: String
    let phone: Int
    let zip: Int
}
