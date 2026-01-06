import SnapKit
import UIKit

class HomeVC: UIViewController {

    private let vm: HomeVM
    
    private let pageLabel: UILabel = {
       let lbl = UILabel()
        lbl.font = UIFont(name: "Poppins-SemiBold", size: 18)
        lbl.textColor = UIColor(named: "textColor")
        lbl.text = "What do you want to watch?"
        return lbl
    }()
    private lazy var searchBar = CustomSearchBar()

    init(vm: HomeVM) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    private func setupUI(){
        view.backgroundColor = UIColor(named: "bgColor")
        searchBar.delegate = self
        addSubViews()
        addConstraints()
    }
    private func addSubViews(){
        view.addSubview(pageLabel)
        view.addSubview(searchBar)
    }
    private func addConstraints(){
        pageLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(pageLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
    }
}

extension HomeVC: UISearchBarDelegate {
    
}
