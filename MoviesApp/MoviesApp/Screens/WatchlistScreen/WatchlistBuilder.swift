import Foundation

final class WatchlistBuilder {
    func build() -> WatchlistVC {
        let vm = WatchlistVM()
        return WatchlistVC(vm: vm)
    }
}
