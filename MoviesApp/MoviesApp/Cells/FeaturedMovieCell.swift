import UIKit
import SnapKit

final class FeaturedMovieCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: FeaturedMovieCell.self)
    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        return iv
    }()

    private let indexLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.backgroundColor = .clear
        lbl.textColor = UIColor(named: "bgColor") ?? .black
        lbl.font = UIFont(name: "Montserrat-Bold", size: 140)
            ?? .systemFont(ofSize: 110, weight: .semibold)
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
            make.top.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-32)
        }
        indexLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().offset(20)
        }
    }
    func configure(image: UIImage?, index: Int) {
        posterImageView.image = image

        let attributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor(named: "activeColor") ?? UIColor.blue,
            .strokeWidth: -1
        ]

        indexLabel.attributedText = NSAttributedString(
            string: "\(index)",
            attributes: attributes
        )
    }

}
