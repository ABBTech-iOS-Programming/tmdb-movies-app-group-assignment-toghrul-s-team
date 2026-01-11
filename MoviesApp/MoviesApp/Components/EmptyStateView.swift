import SnapKit
import UIKit

final class EmptyStateView: UIView {
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        sv.spacing = 12
        return sv
    }()

    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()

    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Montserrat-SemiBold", size: 20)
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.textColor = UIColor(named: "thirdTextColor")
        return lbl
    }()

    private let subtitleLabel: UILabel = {
        let lbl = UILabel()
        let font = UIFont(name: "Montserrat-Medium", size: 15) ?? .systemFont(ofSize: 15)
        let lineHeight: CGFloat = 24
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight
        paragraphStyle.alignment = .center
        let baselineOffset = (lineHeight - font.lineHeight) / 2
        lbl.attributedText = NSAttributedString(
            string: "",
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)

        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(120)
        }
    }

    func configure(imageName: String, title: String, subtitle: String? = nil) {
        imageView.image = UIImage(named: imageName)
        titleLabel.text = title.capitalized

        if let subtitle = subtitle {
            let font = UIFont(name: "Montserrat-Medium", size: 15) ?? .systemFont(ofSize: 15)
            let lineHeight: CGFloat = 24
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.minimumLineHeight = lineHeight
            paragraphStyle.maximumLineHeight = lineHeight
            paragraphStyle.alignment = .center
            let baselineOffset = (lineHeight - font.lineHeight) / 2

            subtitleLabel.attributedText = NSAttributedString(
                string: subtitle,
                attributes: [
                    .font: font,
                    .paragraphStyle: paragraphStyle,
                    .baselineOffset: baselineOffset
                ]
            )
            subtitleLabel.isHidden = false
        } else {
            subtitleLabel.isHidden = true
        }
    }
}
