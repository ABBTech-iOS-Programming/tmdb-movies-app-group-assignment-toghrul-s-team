import SnapKit
import UIKit

final class HomeVC: UIViewController {
    private let vm: HomeVM
    let spinner = UIActivityIndicatorView(style: .large)
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = true
        sv.contentInsetAdjustmentBehavior = .never
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    

    
    private let trendingLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Poppins-SemiBold", size: 30)
        lbl.textColor = UIColor(named: "textColor")
        lbl.text = "Trending"
        return lbl
    }()
    
    private lazy var searchBar = CustomSearchBar()
    
    private lazy var searchTableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.reuseIdentifier)
        tv.dataSource = self
        tv.delegate = self
        tv.isHidden = true
        return tv
    }()
    
    private let emptyStateView: EmptyStateView = {
        let view = EmptyStateView()
        view.isHidden = true
        view.configure(
            imageName: "no-search",
            title: "we are sorry, we can\n not find the movie :(",
            subtitle: "Find your movie by Type title,\n categories, years, etc "
        )
        return view
    }()
    
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
        let interSpacing: CGFloat = 10
        let width = (UIScreen.main.bounds.width - (spacing * 2) - (interSpacing * 2)) / 3
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = interSpacing
        layout.minimumInteritemSpacing = interSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        layout.estimatedItemSize = CGSize(width: width, height: 180)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
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
        setupNavigationBar()
        setupUI()
        bindViewModel()
        vm.loadFeatured()
        vm.loadCategoricMovies(of: .nowPlaying)
        updateUIState()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        title = "What do you want to watch?"
        tabBarController?.tabBar.items?[0].title = "Home"
        
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(named: "bgColor")
            
            if let customFont = UIFont(name: "Poppins-SemiBold", size: 22) {
                appearance.largeTitleTextAttributes = [
                    .foregroundColor: UIColor(named: "textColor") ?? .label,
                    .font: customFont
                ]
            }
            
            if let customFont = UIFont(name: "Poppins-SemiBold", size: 17) {
                appearance.titleTextAttributes = [
                    .foregroundColor: UIColor(named: "textColor") ?? .label,
                    .font: customFont
                ]
            }
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
        
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "bgColor")
        searchBar.delegate = self
        addSubVews()
        addConstraints()
    }
    
    private func addSubVews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [trendingLabel,featuredCollectionView,categoryCollectionView,mainFilmsCollectionView].forEach(contentView.addSubview)
        [searchBar,spinner,emptyStateView,searchTableView].forEach(view.addSubview)
    }
    
    private func addConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        trendingLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
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
            make.height.equalTo(1000)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        searchTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyStateView.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
    }
    
    private func bindViewModel() {
        vm.onLoading = { [weak self] isLoading in
            guard let self else { return }
            isLoading ? self.spinner.startAnimating() : self.spinner.stopAnimating()
        }
        
        vm.onFeaturedUpdated = { [weak self] in
            self?.featuredCollectionView.reloadData()
        }
        
        vm.onNowPlayingUpdated = { [weak self] in
            guard let self else { return }
            self.mainFilmsCollectionView.reloadData()
            self.updateCollectionViewHeight()
        }
        
        vm.onResultsUpdated = { [weak self] in
            guard let self else { return }
            self.updateUIState()
        }
        
        vm.onError = { error in
            print("Error:", error)
        }
    }
    
    private func updateCollectionViewHeight() {
        mainFilmsCollectionView.layoutIfNeeded()
        let height = mainFilmsCollectionView.collectionViewLayout.collectionViewContentSize.height
        mainFilmsCollectionView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
    }
    
    private func updateUIState() {
        let searchText = searchBar.text ?? ""
        let hasData = !vm.searchedFilms.isEmpty
        
        if searchText.isEmpty {
            showHomepageContent(true)
            searchTableView.isHidden = true
            emptyStateView.isHidden = true
            scrollView.isHidden = false
        } else {
            showHomepageContent(false)
            scrollView.isHidden = true
            if hasData {
                searchTableView.isHidden = false
                emptyStateView.isHidden = true
            } else {
                searchTableView.isHidden = true
                emptyStateView.isHidden = false
            }
        }
        
        searchTableView.reloadData()
    }
    
    private func showHomepageContent(_ show: Bool) {
        trendingLabel.isHidden = !show
        featuredCollectionView.isHidden = !show
        categoryCollectionView.isHidden = !show
        mainFilmsCollectionView.isHidden = !show
    }
}

extension HomeVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            vm.searchedFilms = []
            updateUIState()
        } else {
            vm.loadCategoricMovies(text: searchText)
        }
    }
}

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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
                    guard let data, let image = UIImage(data: data) else { return }
                    DispatchQueue.main.async {
                        if collectionView.indexPath(for: cell) == indexPath {
                            cell.configure(image: image, index: indexPath.item + 1)
                        }
                    }
                }.resume()
            }
            return cell
        } else if collectionView.tag == 1 {
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
                guard let data, let image = UIImage(data: data) else { return }
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
            updateCollectionViewHeight()
            return
        }
        
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

extension HomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vm.searchedFilms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        
        let movie = vm.searchedFilms[indexPath.row]
        cell.configure(
            title: movie.title,
            star: movie.voteAverage,
            type: "Action",
            date: movie.releaseDate,
            duration: "139 Minutes"
        )
        
        if let url = vm.posterURL(for: movie) {
            URLSession.shared.dataTask(with: url) { [weak tableView] data, _, _ in
                guard let data, let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    if tableView?.indexPath(for: cell) == indexPath {
                        cell.configureImage(image)
                    }
                }
            }.resume()
        }
        
        return cell
    }
}

extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movieId = vm.searchedFilms[indexPath.row].id
        let detailVC = DetailBuilder.build(movieId: movieId)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
