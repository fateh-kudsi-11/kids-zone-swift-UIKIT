

enum Gender {
    case boys
    case girls

    var stringValue: String {
        switch self {
        case .boys:
            return "boys"
        case .girls:
            return "girls"
        }
    }
}

enum Sort {
    case new
    case highToLow
    case lowToHigh

    var stringValue: String {
        switch self {
        case .new:
            return "newProduct"
        case .highToLow:
            return "priceHighToLow"
        case .lowToHigh:
            return "priceLowToHigh"
        }
    }
}

class FilterOptions {
    var gender: Gender = .boys
    var directory: String = ""
    var sort: Sort = .new
    var filterOutput = [
        "brand": "",
        "color": "",
        "size": "",
        "priceRange": ""
    ]
}
