import Foundation

final class DetailBuilder{
    func build() -> DetailVC {
        let vm = DetailVM()
        
        return DetailVC(vm: vm)
    }
}
