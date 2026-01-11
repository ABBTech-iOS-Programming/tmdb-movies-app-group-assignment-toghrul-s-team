import SnapKit
import UIKit

final class WatchListTVC: UITableViewCell {
    static let reuseIdentifier = String(describing: WatchListTVC.self)
    private let FilmImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = ""
        lbl.font = UIFont(name: "Poppins-Medium", size: 16)
        return lbl
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        FilmImageView.image = nil
        nameLabel.text = nil
    }
}
