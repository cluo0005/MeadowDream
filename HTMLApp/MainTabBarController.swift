import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupViewControllers()
    }
    
    private func setupAppearance() {
        // Set tab bar appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        
        tabBar.tintColor = Theme.primary
    }
    
    private func setupViewControllers() {
        viewControllers = [
            createNavigationController(
                for: DreamJournalViewController(),
                title: "Journal",
                image: UIImage(systemName: "book.fill")!
            ),
            createNavigationController(
                for: RecordDreamViewController(),
                title: "Record",
                image: UIImage(systemName: "plus.circle.fill")!
            ),
            createNavigationController(
                for: StatisticsViewController(),
                title: "Stats",
                image: UIImage(systemName: "chart.bar.fill")!
            ),
            createNavigationController(
                for: InterpretationViewController(),
                title: "Interpret",
                image: UIImage(systemName: "sparkles")!
            ),
            createNavigationController(
                for: SettingsViewController(),
                title: "Settings",
                image: UIImage(systemName: "gearshape.fill")!
            )
        ]
    }
    
    private func createNavigationController(for rootViewController: UIViewController,
                                         title: String,
                                         image: UIImage) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        rootViewController.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        
        // Set navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [
            .font: Theme.font(size: 18, weight: .semibold)
        ]
        
        navController.navigationBar.standardAppearance = appearance
        navController.navigationBar.scrollEdgeAppearance = appearance
        navController.navigationBar.tintColor = Theme.primary
        
        return navController
    }
} 