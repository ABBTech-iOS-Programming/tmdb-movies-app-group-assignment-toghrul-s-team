import Foundation

final class HomeBuilder {
    func build() -> HomeVC {
        let vm = HomeVM()
        
        return HomeVM(vm: vm)
    }
}
