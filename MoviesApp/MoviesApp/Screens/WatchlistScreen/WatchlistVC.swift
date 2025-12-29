import SnapKit
import UIKit

final class WatchlistVC: UIViewController {
    private let vm: WatchlistVM
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    init(vm: WatchlistVM) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
