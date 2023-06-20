

enum Gender {
    case boys
    case girls
}

struct FilterOptions {
    static var shared = FilterOptions()

    var gender: Gender = .boys
}
