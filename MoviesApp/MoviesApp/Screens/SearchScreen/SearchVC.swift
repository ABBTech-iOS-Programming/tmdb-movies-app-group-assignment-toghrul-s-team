import SnapKit
import UIKit

final class SearchVC: UIViewController {
    let vm: SearchVM

    private let spinner = UIActivityIndicatorView(style: .large)

    private lazy var searchBar = CustomSearchBar()
    private lazy var searchTableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.reuseIdentifier)
        tv.dataSource = self
        tv.delegate = self
        return tv
    }()

    private let defaultLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Montserrat-Medium", size: 16) ?? .systemFont(ofSize: 16)
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.textColor = UIColor(named: "thirdTextColor")
        lbl.text = "Find your movie by Type title,\n categories, years, etc"
        return lbl
    }()

    private let emptyStateView: EmptyStateView = {
        let view = EmptyStateView()
        view.configure(
            imageName: "no-search",
            title: "we are sorry, we can\n not find the movie :(",
            subtitle: "Find your movie by Type title,\n categories, years, etc "
        )
        return view
    }()

    init(vm: SearchVM) {
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
        bindVM()
        updateUIState()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func setupUI() {
        view.backgroundColor = UIColor(named: "bgColor")
        setupNav()
        searchBar.delegate = self
        addSubViews()
        setupConstraints()
        closeKeyboardTapGesture()
    }

    private func addSubViews() {
        [searchBar,
         defaultLabel,
         emptyStateView,
         searchTableView,
         spinner].forEach(view.addSubview)
    }
    
    private func  closeKeyboardTapGesture(){
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    private func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }

        defaultLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
        }

        emptyStateView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        searchTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }

        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func setupNav() {
        let chevronImage = UIImage(systemName: "chevron.left")

        navigationItem.titleView = TitleLabel("Search")

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: chevronImage,
            style: .done,
            target: self,
            action: #selector(goBack)
        )

        navigationItem.leftBarButtonItem?.tintColor =
            UIColor(named: "thirdTextColor") ?? .white
    }

    private func bindVM() {
        vm.onLoading = { [weak self] isLoading in
            guard let self else { return }

            isLoading ? self.spinner.startAnimating() : self.spinner.stopAnimating()
        }

        vm.onResultsUpdated = { [weak self] in
            guard let self else { return }

            self.updateUIState()
        }

        vm.onError = { error in
            print("Error:", error)
        }
    }

    private func updateUIState() {
        let searchText = searchBar.text ?? ""
        let hasData = !vm.searchedFilms.isEmpty

        if searchText.isEmpty {
            defaultLabel.isHidden = false
            searchTableView.isHidden = true
            emptyStateView.isHidden = true
        } else {
            if hasData {
                defaultLabel.isHidden = true
                searchTableView.isHidden = false
                emptyStateView.isHidden = true
            } else {
                defaultLabel.isHidden = true
                searchTableView.isHidden = true
                emptyStateView.isHidden = false
            }
        }

        searchTableView.reloadData()
    }

    @objc private func goBack() {
        tabBarController?.selectedIndex = 0
    }
}

extension SearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vm.searchedFilms.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
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
                guard let data,
                      let image = UIImage(data: data) else { return }

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

extension SearchVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            vm.searchedFilms = []
            updateUIState()
        } else {
            vm.loadCategoricMovies(text: searchText)
        }
    }
}

extension SearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movieId = vm.searchedFilms[indexPath.row].id
        let detailVC = DetailBuilder.build(movieId: movieId)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
