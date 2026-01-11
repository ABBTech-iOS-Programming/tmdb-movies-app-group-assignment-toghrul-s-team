import SnapKit
import UIKit

final class WatchlistVC: UIViewController {

    private let vm = WatchlistVM()
    private var movies: [MovieSummary] = []

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
        tv.register(WatchlistCell.self, forCellReuseIdentifier: "WatchlistCell")
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        movies = vm.fetchMovies()
        tableView.reloadData()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(named: "bgColor")
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(tableView)
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
    }
}

extension WatchlistVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "WatchlistCell",
            for: indexPath
        ) as? WatchlistCell else
        {return UITableViewCell()}

        cell.configure(with: movies[indexPath.row])
        return cell
    }
}
