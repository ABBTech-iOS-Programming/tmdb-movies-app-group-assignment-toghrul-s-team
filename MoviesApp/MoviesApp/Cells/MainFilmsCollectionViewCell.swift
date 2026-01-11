import SnapKit
import UIKit

final class MainFilmsCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: MainFilmsCollectionViewCell.self)

    private let filmImage: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 16
        img.clipsToBounds = true
        return img
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        filmImage.image = nil
    }

    private func setupUI() {
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        contentView.addSubview(filmImage)
    }

    private func setupConstraints() {
        filmImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configure(image: UIImage?) {
        filmImage.image = image
    }
}
