import SnapKit
import UIKit

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
        addTopSeparator()
    }

    private func setupTabs() {
        let homeVC = HomeBuilder().build()
        let searchVC = SearchBuilder().build()
        let watchListVC = WatchlistBuilder().build()

        let homeNav = UINavigationController(rootViewController: homeVC)
        let searchNav = UINavigationController(rootViewController: searchVC)
        let watchNav = UINavigationController(rootViewController: watchListVC)

        homeNav.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )

        searchNav.tabBarItem = UITabBarItem(
            title: "Search",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass")
        )

        watchNav.tabBarItem = UITabBarItem(
            title: "Watchlist",
            image: UIImage(systemName: "bookmark"),
            selectedImage: UIImage(systemName: "bookmark.fill")
        )

        viewControllers = [homeNav, searchNav, watchNav]
    }

    private func setupAppearance() {
        tabBar.tintColor = UIColor(named: "activeColor")
        tabBar.unselectedItemTintColor = UIColor(named: "tintColor")
        tabBar.isTranslucent = false

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "bgColor")

        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.iconColor = UIColor(named: "tintColor")
        itemAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(named: "tintColor") ?? .gray
        ]
        itemAppearance.selected.iconColor = UIColor(named: "activeColor")
        itemAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(named: "activeColor") ?? .systemBlue
        ]

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }

    private func addTopSeparator() {
        let separator = UIView()
        separator.backgroundColor = UIColor(named: "activeColor")
        tabBar.addSubview(separator)

        separator.snp.makeConstraints { make in
            make.top.equalTo(tabBar.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(2)
        }
    }
}
