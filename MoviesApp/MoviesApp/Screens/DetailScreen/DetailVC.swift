import SnapKit
import UIKit

final class DetailVC: UIViewController {
    private let vm: DetailVM
    private var currentDetail: MovieDetailResponse?

    private let spinner = UIActivityIndicatorView(style: .large)

    private let backButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        btn.tintColor = .white
        return btn
    }()

    private let topTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Detail"
        lbl.textColor = .white
        lbl.font = .boldSystemFont(ofSize: 18)
        return lbl
    }()

    private let bookmarkButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "bookmark"), for: .normal)
        btn.tintColor = .white
        return btn
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        
        return sv
    }()

    private let contentView: UIView = {
        let v = UIView()
        
        return v
    }()

    private let backdropImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        return iv
    }()

    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = .boldSystemFont(ofSize: 22)
        lbl.numberOfLines = 0
        return lbl
    }()

    private let metaLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .lightGray
        lbl.font = .systemFont(ofSize: 13)
        lbl.numberOfLines = 0
        return lbl
    }()

    private let ratingLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = .boldSystemFont(ofSize: 16)
        return lbl
    }()

    private let segmented: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["About", "Reviews"])
        sc.selectedSegmentIndex = 0
        return sc
    }()

    private let aboutLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = .systemFont(ofSize: 15)
        lbl.numberOfLines = 0
        return lbl
    }()

    private let reviewsTableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.isHidden = true
        return tv
    }()

    init(vm: DetailVM) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindVM()
        vm.loadDetail()
        vm.loadReviews()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(named: "bgColor")
        addSubviews()
        setupConstraints()

        segmented.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        reviewsTableView.dataSource = self
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        bookmarkButton.addTarget(self, action: #selector(bookmarkTapped), for: .touchUpInside)
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }

    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [
            backdropImageView,
            posterImageView,
            titleLabel,
            metaLabel,
            ratingLabel,
            segmented,
            aboutLabel, reviewsTableView
        ].forEach { contentView.addSubview($0) }

        view.addSubview(backButton)
        view.addSubview(topTitleLabel)
        view.addSubview(bookmarkButton)
        view.addSubview(spinner)
    }

    private func setupConstraints() {
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.size.equalTo(24)
        }

        topTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backButton)
        }

        bookmarkButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(backButton)
            $0.size.equalTo(24)
        }

        scrollView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(110)
            
        }

        contentView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.width.equalToSuperview()
        }

        backdropImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(320)
        }

        posterImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(backdropImageView.snp.bottom).offset(-60)
            $0.width.equalTo(120)
            $0.height.equalTo(180)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(backdropImageView.snp.bottom).offset(12)
            $0.leading.equalTo(posterImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(16)
        }

        metaLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.leading.trailing.equalTo(titleLabel)
        }

        ratingLabel.snp.makeConstraints {
            $0.top.equalTo(metaLabel.snp.bottom).offset(6)
            $0.leading.equalTo(metaLabel)
        }

        spinner.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        segmented.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        aboutLabel.snp.makeConstraints {
            $0.top.equalTo(segmented.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        reviewsTableView.snp.makeConstraints {
            $0.top.equalTo(segmented.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(400)
            $0.bottom.equalToSuperview().offset(-20)
        }
    }

    private func bindVM() {
        vm.onLoading = { [weak self] isLoading in
            guard let self else { return }

            isLoading ? self.spinner.startAnimating() : self.spinner.stopAnimating()
        }

        vm.onDetailLoaded = { [weak self] detail in
            guard let self else { return }

            self.currentDetail = detail
            titleLabel.text = detail.title
            aboutLabel.text = detail.overview
            ratingLabel.text = "⭐️ \(String(format: "%.1f", detail.voteAverage))"

            let year = detail.releaseDate.map { String($0.prefix(4)) } ?? "-"
            let runtime = detail.runtime.map { "\($0) min" } ?? "-"
            let genres = detail.genres?
                .map { $0.name }
                .joined(separator: ", ") ?? "-"
            metaLabel.text = "\(year) • \(runtime) • \(genres)"

            if let p = detail.posterPath {
                self.loadImage(path: p, into: self.posterImageView, size: "w342")
            }
            if let b = detail.backdropPath {
                self.loadImage(path: b, into: self.backdropImageView, size: "w780")
            }
        }

        vm.onWatchlistStateChanged = { [weak self] isSaved in
            let name = isSaved ? "bookmark.fill" : "bookmark"
            self?.bookmarkButton
                .setImage(
                    UIImage(
                        systemName: name
                    ),
                    for: .normal
                )
        }

        vm.onReviewsLoaded = { [weak self] _ in
            self?.reviewsTableView
                .reloadData()
        }

        vm.onError = { error in
            print(error)
        }
    }

    @objc private func bookmarkTapped() {
        guard let detail = currentDetail else { return }

        vm.toggleWatchlist(detail: detail)
    }

    @objc private func segmentChanged() {
        let isAbout = segmented.selectedSegmentIndex == 0
        aboutLabel.isHidden = !isAbout
        reviewsTableView.isHidden = isAbout
    }

    private func loadImage(path: String, into iv: UIImageView, size: String) {
        let url = URL(string: "https://image.tmdb.org/t/p/\(size)\(path)")!
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data, let img = UIImage(data: data) else { return }

            DispatchQueue.main.async { iv.image = img }
        }.resume()
    }
}

extension DetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vm.reviews.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let r = vm.reviews[indexPath.row]
        cell.textLabel?.text = r.author
        cell.detailTextLabel?.text = r.content
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .lightGray
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
}
