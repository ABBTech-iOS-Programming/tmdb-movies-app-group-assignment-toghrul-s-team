import SnapKit
import UIKit

final class CustomSearchBar: UISearchBar {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        searchBarStyle = .minimal
        placeholder = "Search"

        let textField = searchTextField
        textField.backgroundColor = UIColor(named: "secondaryBgColor") ?? .darkGray
        textField.textColor = .white
        textField.font = UIFont(name: "Poppins-Medium", size: 16)

        textField.layer.cornerRadius = 16
        textField.clipsToBounds = true

        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [
                .foregroundColor: UIColor(named: "tintColor") ?? .systemGray3
            ]
        )

        if let leftIcon = textField.leftView as? UIImageView {
            leftIcon.tintColor = UIColor(named: "tintColor") ?? .systemGray3
        }
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
