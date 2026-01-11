import SnapKit
import UIKit

final class HomeVC: UIViewController {
    private let vm: HomeVM

    let spinner = UIActivityIndicatorView(style: .large)

    private let pageLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Poppins-SemiBold", size: 22)
        lbl.textColor = UIColor(named: "textColor")
        lbl.text = "What do you want to watch?"
        return lbl
    }()

    private let trendingLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Poppins-SemiBold", size: 30)
        lbl.textColor = UIColor(named: "textColor")
        lbl.text = "Trending"
        return lbl
    }()

    private lazy var searchBar = CustomSearchBar()

    private lazy var featuredCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.estimatedItemSize = CGSize(width: 210, height: 330)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.tag = 0
    
        cv.register(
            FeaturedMovieCell.self,
            forCellWithReuseIdentifier: FeaturedMovieCell.reuseIdentifier
        )
        return cv
    }()

    private lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.estimatedItemSize = CGSize(width: 100, height: 50)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.tag = 1
        cv.delegate = self
        cv.register(
            CategoryCollectionViewCell.self,
            forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier
        )
        return cv
    }()

    private lazy var mainFilmsCollectionView: UICollectionView = {
        let spacing: CGFloat = 24
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        layout.itemSize = CGSize(width: 120, height: 180)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.tag = 2
        cv.register(
            MainFilmsCollectionViewCell.self,
            forCellWithReuseIdentifier: MainFilmsCollectionViewCell.reuseIdentifier
        )
        return cv
    }()

    init(vm: HomeVM) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        vm.loadFeatured()
        vm.loadCategoricMovies(of: .nowPlaying)
    }

    private func setupUI() {
        view.backgroundColor = UIColor(named: "bgColor")
        searchBar.delegate = self
        addSubVews()
        addConstraints()
    }

    private func addSubVews() {
        view.addSubview(pageLabel)
        view.addSubview(searchBar)
        view.addSubview(trendingLabel)
        view.addSubview(featuredCollectionView)
        view.addSubview(categoryCollectionView)
        view.addSubview(mainFilmsCollectionView)
        view.addSubview(spinner)
    }

    private func addConstraints() {
        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        pageLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(pageLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        trendingLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(24)
        }

        featuredCollectionView.snp.makeConstraints { make in
            make.top.equalTo(trendingLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview()
            make.height.equalTo(330)
        }
        categoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(featuredCollectionView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview()
            make.height.equalTo(52)
        }
        mainFilmsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryCollectionView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(20)
        }
    }

    private func bindViewModel() {
        vm.onLoading = { [weak self] isLoading in
            guard let self else { return }

            isLoading ? self.spinner.startAnimating()
                : self.spinner.stopAnimating()
        }
        vm.onFeaturedUpdated = { [weak self] in
            self?.featuredCollectionView.reloadData()
        }
        vm.onNowPlayingUpdated = { [weak self] in
            self?.mainFilmsCollectionView.reloadData()
        }
        
        vm.onError = { error in
            print("Error:", error)
        }
    }
}

extension HomeVC: UISearchBarDelegate {}

extension HomeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        switch collectionView.tag {
        case 0:
            count = vm.featuredMovies.count
        case 1:
            count = vm.fetchCategories().count
        case 2:
            count = vm.nowPlayingMovies.count
        default:
            count = 0
        }
        return count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView.tag == 0 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FeaturedMovieCell.reuseIdentifier,
                for: indexPath
            ) as? FeaturedMovieCell else {
                return UICollectionViewCell()
            }

            let movie = vm.featuredMovies[indexPath.item]

            cell.configure(image: nil, index: indexPath.item + 1)

            if let url = vm.posterURL(for: movie) {
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    guard let data,
                          let image = UIImage(data: data) else { return }

                    DispatchQueue.main.async {
                        if collectionView.indexPath(for: cell) == indexPath {
                            cell.configure(image: image, index: indexPath.item + 1)
                        }
                    }
                }.resume()
            }

            return cell
        }
        else if collectionView.tag == 1 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as? CategoryCollectionViewCell else {
                return UICollectionViewCell()
            }

            cell.configure(text: vm.fetchCategories()[indexPath.item])
            if indexPath.item == 0 {
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            }
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MainFilmsCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? MainFilmsCollectionViewCell else {
            return UICollectionViewCell()
        }
        let movie = vm.nowPlayingMovies[indexPath.item]
        if let url = vm.posterURL(for: movie) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data,
                      let image = UIImage(data: data) else { return }

                DispatchQueue.main.async {
                    if collectionView.indexPath(for: cell) == indexPath {
                        cell.configure(image: image)
                    }
                }
            }.resume()
        }
        return cell
    }
}
extension HomeVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView.tag == 1 {
            vm.loadCategoricMovies(of: CategoricMoviesEndPoint.allCases[indexPath.item])
            mainFilmsCollectionView.reloadData()
            return
        }
        //helelik
        let movieId: Int

        if collectionView.tag == 0 {
            movieId = vm.featuredMovies[indexPath.item].id
        } else {
            movieId = vm.nowPlayingMovies[indexPath.item].id
        }

        let detailVC = DetailBuilder.build(movieId: movieId)
        navigationController?.pushViewController(detailVC, animated: true)

    }

}
