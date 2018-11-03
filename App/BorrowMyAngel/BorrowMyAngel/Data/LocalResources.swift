struct LocalResources {
    static let foodResourceItems = [
        ResourceItem(title: "Civil", phone: 4178802932, zip: 65807),
        ResourceItem(title: "Pete's Pizza", phone: 4178802932, zip: 65807),
        ResourceItem(title: "Waffle House", phone: 4178802932, zip: 12345)
    ]
    
    static let housingResourceItems = [
        ResourceItem(title: "Missouri Hotel", phone: 4178802932, zip: 65802)
    ]
    
    static let therapyResourceItems = [
        ResourceItem(title: "Dr. Doe", phone: 4178802932, zip: 65807),
        ResourceItem(title: "Health Services", phone: 4178802932, zip: 00000)
    ]
    
    static let foodResources = ResourceType(name: "Food", resources: foodResourceItems)
    static let housingResources = ResourceType(name: "Housing", resources: housingResourceItems)
    static let therapyResources = ResourceType(name: "Therapy", resources: therapyResourceItems)
    
    static let allLocalResources = [foodResources, housingResources, therapyResources]
}


