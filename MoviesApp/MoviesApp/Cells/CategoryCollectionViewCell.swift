import SnapKit
import UIKit

final class CategoryCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: CategoryCollectionViewCell.self)

    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = .boldSystemFont(ofSize: 20)
        lbl.textAlignment = .center

        return lbl
    }()

    private let activeBottomLineView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(named: "secondaryBgColor")
        v.isHidden = true
        return v
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
        nameLabel.text = nil
    }

    private func setupUI() {
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(activeBottomLineView)
    }

    private func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(activeBottomLineView.snp.top).offset(-12)
        }
        activeBottomLineView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.height.equalTo(6)
        }
    }

    func configure(text: String) {
        nameLabel.text = text
    }

    override var isSelected: Bool {
        didSet {
            activeBottomLineView.isHidden = isSelected ? false : true
        }
    }
}
