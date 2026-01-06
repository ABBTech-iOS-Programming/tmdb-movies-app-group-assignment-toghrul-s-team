import Foundation

final class SearchBuilder {
    func build() -> SearchVC {
        let vm = SearchVM()
        return SearchVC(vm: vm)
    }
}
