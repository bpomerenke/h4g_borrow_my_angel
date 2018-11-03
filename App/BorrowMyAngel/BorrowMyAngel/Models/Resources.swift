import Foundation

struct ResourceType {
    let name: String
    var resources: [ResourceItem]
}
struct ResourceItem {
    let title: String
    let phone: String
    let zip: Int
    let url: String
}
