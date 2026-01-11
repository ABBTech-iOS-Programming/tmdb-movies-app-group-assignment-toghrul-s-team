//
//  WatchlistCell.swift
//  MoviesApp
//
//  Created by Toghrul Guluzadeh on 11.01.26.
//
import UIKit
import SnapKit

final class WatchlistCell: UITableViewCell {

    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 12
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()

    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = .boldSystemFont(ofSize: 16)
        lbl.numberOfLines = 2
        return lbl
    }()

    private let ratingLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .systemOrange
        lbl.font = .boldSystemFont(ofSize: 14)
        return lbl
    }()

    private let metaLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .lightGray
        lbl.font = .systemFont(ofSize: 13)
        lbl.numberOfLines = 0
        return lbl
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
      addSubviews()
      setupConstraints()
    }
    
    private func setupConstraints(){
        posterImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().offset(-8)
            $0.width.equalTo(80)
            $0.height.equalTo(120)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(posterImageView)
            $0.leading.equalTo(posterImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().offset(-16)
        }

        ratingLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.leading.equalTo(titleLabel)
        }

        metaLabel.snp.makeConstraints {
            $0.top.equalTo(ratingLabel.snp.bottom).offset(6)
            $0.leading.trailing.equalTo(titleLabel)
        }
    }
    
    private func addSubviews(){
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(metaLabel)
    }

    func configure(with movie: MovieSummary) {
        titleLabel.text = movie.title
        ratingLabel.text = "⭐️ \(String(format: "%.1f", movie.voteAverage))"
        metaLabel.text = "Action\n2019\n139 minutes"

        if let path = movie.posterPath {
            let url = URL(string: "https://image.tmdb.org/t/p/w342\(path)")!
            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data else { return }
                DispatchQueue.main.async {
                    self.posterImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
