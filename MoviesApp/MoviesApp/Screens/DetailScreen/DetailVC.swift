import SnapKit
import UIKit

final class DetailVC: UIViewController {
    let vm: DetailVM
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    init(vm: DetailVM) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
