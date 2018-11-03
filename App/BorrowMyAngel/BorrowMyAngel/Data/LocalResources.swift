import Foundation

struct LocalResources {
    static let crisisServicesItems = [
        ResourceItem(title: "Emergency", phone: "911", zip: 65802, url: URL(string: "https://www.911.gov/")!),
        ResourceItem(title: "National Suicide Prevention Hotline", phone: "800-273-8255", zip: 65807, url: URL(string: "https://suicidepreventionlifeline.org/")!),
        ResourceItem(title: "Text Crisis Line", phone: "741741", zip: 65802, url: URL(string: "https://www.crisistextline.org/")!)
    ]
    
    static let professionalHelpItems = [
        ResourceItem(title: "Alliance Counseling Associates", phone: "417-880-7310", zip: 65807, url: URL(string: "https://www.911.gov/")!),
        ResourceItem(title: "Alternatives Inc", phone: "417-883-7227", zip: 65802, url: URL(string: "http://www.missourialternatives.com/")!),
        ResourceItem(title: "Betty and Bobby Allison Ozarks Counseling Center", phone: "417-869-9011", zip: 65807, url: URL(string: "www.ozarkscounselingcenter.org")!),
        ResourceItem(title: "BHG Joplin Treatment Center", phone: "417-782-7966", zip: 64801, url: URL(string: "www.ozarkscounselingcenter.org")!)
    ]
    
    static let otherSupportItems = [
        ResourceItem(title: "Al-Anon, Alateen", phone: "417-823-7125", zip: 65807, url: URL(string: "www.missouri-al-anon.org")!),
        ResourceItem(title: "Alcoholics Anonymous", phone: "417-823-7125", zip: 65802, url: URL(string: "www.aaswmo.org")!),
        ResourceItem(title: "American Foundation for Suicide Prevention", phone: "888-333-2377", zip: 65807, url: URL(string: "www.afsp.org/our-work")!),
        ResourceItem(title: "Big Brothers Big Sisters of the Ozarks", phone: "417-889-9136", zip: 64801, url: URL(string: "www.bigbro.com")!)
    ]
    
    static let crisisServicesResources = ResourceType(name: "Crisis Services", resources: crisisServicesItems)
    static let professionalHelpResources = ResourceType(name: "Professional Help", resources: professionalHelpItems)
    static let otherSupportResources = ResourceType(name: "Other Support Services", resources: otherSupportItems)
    
    static let allLocalResources = [crisisServicesResources, professionalHelpResources, otherSupportResources]
}


