import SnapKit
import UIKit

final class SearchTableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: SearchTableViewCell.self)
    
    private let filmImage = UIImageView()
    private let filmName = UILabel()
    private let horizontalStackview = UIStackView()
    private let verticalStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        filmImage.image = nil
        filmName.text = nil
        for arrangedSubview in verticalStackView.arrangedSubviews {
            if arrangedSubview !== filmName {
                arrangedSubview.removeFromSuperview()
            }
        }
    }

    private func addSubViews() {
        contentView.addSubview(horizontalStackview)
        
        horizontalStackview.addArrangedSubview(filmImage)
        horizontalStackview.addArrangedSubview(verticalStackView)
        
        verticalStackView.addArrangedSubview(filmName)
    }

    private func addConstraints() {
        horizontalStackview.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        filmImage.snp.makeConstraints { make in
            make.width.equalTo(90)
            make.height.equalTo(130)
        }
    }

    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        filmImage.contentMode = .scaleAspectFill
        filmImage.layer.cornerRadius = 16
        filmImage.clipsToBounds = true
        
        filmName.font = UIFont(name: "Poppins-Regular", size: 22)
        filmName.textColor = UIColor(named: "textColor")
        
        horizontalStackview.axis = .horizontal
        horizontalStackview.spacing = 12
        horizontalStackview.alignment = .center
        
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 8
        addSubViews()
        addConstraints()
    }
    
    func configure(
        title: String,
        star: Double,
        type: String,
        date: String,
        duration: String
    ) {
        filmName.text = title
        
        let infos: [(String, String)] = [
            ("star.fill", String(format: "%.1f", star)),
            ("film.fill", type),
            ("calendar", date),
            ("clock", duration)
        ]
        
        for info in infos {
            verticalStackView.addArrangedSubview(makeInfoRow(icon: info.0, text: info.1))
        }
    }
    
    func configureImage(_ image: UIImage?) {
        filmImage.image = image
    }
    
    private func makeInfoRow(icon: String, text: String) -> UIStackView {
        let iv = UIImageView(image: UIImage(systemName: icon))
        iv.tintColor = .systemOrange
        iv.snp.makeConstraints { $0.size.equalTo(18) }
        
        let lbl = UILabel()
        lbl.text = text
        lbl.font = UIFont(name: "Poppins-Regular", size: 16)
        lbl.textColor = UIColor(named: "textColor")
        
        let sv = UIStackView(arrangedSubviews: [iv, lbl])
        sv.axis = .horizontal
        sv.spacing = 8
        sv.alignment = .center
        return sv
    }
}
