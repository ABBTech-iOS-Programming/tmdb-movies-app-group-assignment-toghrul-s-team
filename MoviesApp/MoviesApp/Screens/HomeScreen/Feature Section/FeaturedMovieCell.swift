import UIKit
import SnapKit

final class FeaturedMovieCell: UICollectionViewCell {

    static let id = "FeaturedMovieCell"
    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    private let indexLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = .boldSystemFont(ofSize: 24)
        return lbl
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        indexLabel.text = nil
    }

    private func setupUI() {
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(indexLabel)
    }

    private func setupConstraints() {
        posterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        indexLabel.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(12)
        }
    }

    func configure(image: UIImage?, index: Int) {
        indexLabel.text = "\(index)"
        posterImageView.image = image
    }
}
