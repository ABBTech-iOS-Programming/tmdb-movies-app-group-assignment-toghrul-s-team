import SnapKit
import UIKit

class HomeVC: UIViewController {
    private let vm: HomeVM
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    init(vm: HomeVM) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


}

