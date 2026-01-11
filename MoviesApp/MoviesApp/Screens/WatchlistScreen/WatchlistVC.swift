import SnapKit
import UIKit

final class WatchlistVC: UIViewController {
    private let vm: WatchlistVM

    private let backButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        btn.tintColor = .white
        return btn
    }()

    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Watch list"
        lbl.textColor = .white
        lbl.font = .boldSystemFont(ofSize: 18)
        return lbl
    }()

    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.dataSource = self
        tv.delegate = self
        tv.register(WatchlistCell.self, forCellReuseIdentifier: WatchlistCell.reuseIdentifier)
        return tv
    }()

    private let emptyStateView: EmptyStateView = {
        let view = EmptyStateView()
        view.configure(
            imageName: "no-watchlist",
            title: "Your watchlist is empty",
            subtitle: "Find your movie by Type title,\n categories, years, etc "
        )
        return view
    }()

    init(vm: WatchlistVM) {
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.fetchMovies()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(named: "bgColor")
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        addSubviews()
        setupConstraints()
    }

    private func bindVM() {
        vm.onMoviesUpdated = { [weak self] in
            guard let self else { return }
            self.updateUIState()
        }
    }

    @objc private func backTapped() {
        tabBarController?.selectedIndex = 0
    }

    private func addSubviews() {
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(emptyStateView)
    }

    private func setupConstraints() {
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.size.equalTo(24)
        }

        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backButton)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        emptyStateView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    private func updateUIState() {
        let hasData = !vm.movies.isEmpty
        tableView.isHidden = !hasData
        emptyStateView.isHidden = hasData
        tableView.reloadData()
    }
}

extension WatchlistVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vm.movies.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: WatchlistCell.reuseIdentifier,
            for: indexPath
        ) as? WatchlistCell else {
            return UITableViewCell()
        }

        let movie = vm.movies[indexPath.row]

        cell.configure(
            title: movie.title,
            star: movie.voteAverage,
            type: "Action",
            date: "13-07-2024",
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

extension WatchlistVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movieId = vm.movies[indexPath.row].id
        let detailVC = DetailBuilder.build(movieId: movieId)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
