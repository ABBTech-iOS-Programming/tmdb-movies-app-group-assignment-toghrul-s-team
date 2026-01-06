import UIKit

final class TitleLabel: UILabel {

    init(_ text: String) {
        super.init(frame: .zero)
        self.text = text
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        textColor = UIColor(named: "thirdTextColor") ?? .white
        font = UIFont(name: "Poppins-SemiBold", size: 17)
        textAlignment = .center
    }
}
