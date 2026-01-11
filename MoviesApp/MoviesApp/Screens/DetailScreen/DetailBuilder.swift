import Foundation

final class DetailBuilder {
    static func build(movieId: Int) -> DetailVC {
        let vm = DetailVM(movieId: movieId)
        return DetailVC(vm: vm)
    }
} 
