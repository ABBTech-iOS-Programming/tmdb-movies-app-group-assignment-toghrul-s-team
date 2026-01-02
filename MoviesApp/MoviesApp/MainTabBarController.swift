//
//  MainTabBarController.swift
//  MoviesApp
//
//  Created by Toghrul Guluzadeh on 02.01.26.
//
import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
    }
    
    private func setupTabs() {
        let homeVC = HomeBuilder().build()
//        let searchVC = SearchVC()
        //added like this to prevent compiler err for now
        let searchVC = WatchlistBuilder().build()
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
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .lightGray
        tabBar.barTintColor = .black
        tabBar.isTranslucent = false
    }


}
