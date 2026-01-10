import SnapKit
import UIKit

final class SearchVC: UIViewController {
    let vm: SearchVM

    private lazy var searchBar = CustomSearchBar()
    private lazy var searchTableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.reuseIdentifier)
        tv.dataSource = self
        return tv
    }()

    private let noFimStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        sv.spacing = 12
        return sv
    }()

    private let noFilmImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "no-search")
        image.contentMode = .scaleAspectFit
        return image
    }()

    private let noFilmLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Montserrat-SemiBold", size: 20)
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.textColor = UIColor(named: "thirdTextColor")
        lbl.text = "we are sorry, we can\n not find the movie :(".capitalized
        return lbl
    }()

    private let noFilmSubLabel: UILabel = {
        let lbl = UILabel()

        let font = UIFont(name: "Montserrat-Medium", size: 15) ?? .systemFont(ofSize: 15)
        let lineHeight: CGFloat = 24

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight
        paragraphStyle.alignment = .center

        let baselineOffset = (lineHeight - font.lineHeight) / 2

        lbl.attributedText = NSAttributedString(
            string: "Find your movie by Type title,\n categories, years, etc ",
            attributes: [
                .font: font,
                .paragraphStyle: paragraphStyle,
                .baselineOffset: baselineOffset
            ]
        )

        lbl.numberOfLines = 0
        lbl.textColor = UIColor(named: "subColor")
        return lbl
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
    }

    private func setupUI() {
        view.backgroundColor = UIColor(named: "bgColor")
        setupNav()
        searchBar.delegate = self
        addSubViews()
        setupConstraints()
    }

    private func addSubViews() {
        view.addSubview(searchBar)

        [noFilmImage, noFilmLabel, noFilmSubLabel]
            .forEach(noFimStackView.addArrangedSubview)

        view.addSubview(noFimStackView)
        view.addSubview(searchTableView)
    }

    private func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }

        noFimStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        noFilmImage.snp.makeConstraints { make in
            make.width.height.equalTo(120)
        }
        searchTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview().inset(24)
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
//        vm.onLoading = { [weak self] isLoading in
//            guard let self else { return }
        // spinner ucun lazim olacaq
        // isLoading ? spinner.startAnimating() : spinner.stopAnimating()
//        }

        vm.onResultsUpdated = { [weak self] in
            guard let self else { return }

            let hasData = !self.vm.searchedFilms.isEmpty

            self.searchTableView.isHidden = !hasData
            self.noFimStackView.isHidden = hasData

            self.searchTableView.reloadData()
        }

        vm.onError = { error in
            print("Error:", error)
        }
    }

    @objc private func goBack() {
        tabBarController?.selectedIndex = 0
    }

    private func showEmptyState(_ show: Bool) {
        noFimStackView.isHidden = !show
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
        vm.loadCategoricMovies(text: searchText)
    }
}
