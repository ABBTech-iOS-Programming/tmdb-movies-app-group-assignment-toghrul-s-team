import SnapKit
import UIKit

final class HomeVC: UIViewController {

    private let vm: HomeVM

    private let pageLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Poppins-SemiBold", size: 18)
        lbl.textColor = UIColor(named: "textColor")
        lbl.text = "What do you want to watch?"
        return lbl
    }()

    private lazy var searchBar = CustomSearchBar()

    private lazy var featuredCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.itemSize = CGSize(width: 260, height: 180)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.register(
            FeaturedMovieCell.self,
            forCellWithReuseIdentifier: FeaturedMovieCell.id
        )
        return cv
    }()

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
        bindViewModel()
        vm.loadFeatured()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(named: "bgColor")
        searchBar.delegate = self
        view.addSubview(pageLabel)
        view.addSubview(searchBar)
        view.addSubview(featuredCollectionView)

        pageLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(24)
        }

        searchBar.snp.makeConstraints { make in
            make.top.equalTo(pageLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }

        featuredCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview()
            make.height.equalTo(180)
        }
    }

    private func bindViewModel() {
        vm.onFeaturedUpdated = { [weak self] in
            self?.featuredCollectionView.reloadData()
        }

        vm.onError = { error in
            print(error)
        }
    }
}

extension HomeVC: UISearchBarDelegate { }

extension HomeVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int {
        vm.featuredMovies.count
    }

    func collectionView(_ collectionView: UICollectionView,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FeaturedMovieCell.id,
            for: indexPath
        ) as? FeaturedMovieCell else { return UICollectionViewCell()}
        let movie = vm.featuredMovies[indexPath.item]
        cell.configure(image: nil, index: indexPath.item + 1)

        if let url = vm.posterURL(for: movie) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard
                    let self,
                    let data,
                    let image = UIImage(data: data)
                else { return }
                DispatchQueue.main.async {
                    if collectionView.indexPath(for: cell) == indexPath {
                        cell.configure(image: image, index: indexPath.item + 1)
                    }
                }
            }.resume()
        }
        return cell
    }
}
