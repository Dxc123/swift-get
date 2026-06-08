import Foundation

public struct ProjectScaffolder {
    private let renderer = TemplateRenderer()

    public init() {}

    public func plan(context: ProjectTemplateContext) throws -> ScaffoldPlan {
        try NameValidator.validateTypeName(context.appName)
        try NameValidator.validateBundleID(context.bundleID)

        let values = [
            "appName": context.appName,
            "bundleID": context.bundleID,
            "organizationName": context.organizationName
        ]

        let files = try projectTemplates().map { template in
            PlannedFile(
                relativePath: try renderer.render(template.relativePath, values: values),
                contents: try renderer.render(template.contents, values: values)
            )
        }

        return ScaffoldPlan(root: context.destination, files: files)
    }

    private func projectTemplates() -> [PlannedFile] {
        [
            PlannedFile(relativePath: "{{appName}}/App/AppDelegate.swift", contents: appDelegateTemplate),
            PlannedFile(relativePath: "{{appName}}/App/SceneDelegate.swift", contents: sceneDelegateTemplate),
            PlannedFile(relativePath: "{{appName}}/App/AppCoordinator.swift", contents: appCoordinatorTemplate),
            PlannedFile(relativePath: "{{appName}}/Modules/Home/HomeViewController.swift", contents: homeViewControllerTemplate),
            PlannedFile(relativePath: "{{appName}}/Modules/Home/HomeView.swift", contents: homeViewTemplate),
            PlannedFile(relativePath: "{{appName}}/Modules/Home/HomeViewModel.swift", contents: homeViewModelTemplate),
            PlannedFile(relativePath: "{{appName}}/Resources/Info.plist", contents: infoPlistTemplate),
            PlannedFile(relativePath: "{{appName}}Tests/{{appName}}Tests.swift", contents: testsTemplate),
            PlannedFile(relativePath: "{{appName}}.xcodeproj/project.pbxproj", contents: pbxprojTemplate),
            PlannedFile(relativePath: "README.md", contents: readmeTemplate)
        ]
    }
}

private let appDelegateTemplate = """
import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        true
    }
}
"""

private let sceneDelegateTemplate = """
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var coordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        let coordinator = AppCoordinator(navigationController: navigationController)
        coordinator.start()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
        self.coordinator = coordinator
    }
}
"""

private let appCoordinatorTemplate = """
import UIKit

protocol Coordinator: AnyObject {
    func start()
}

final class AppCoordinator: Coordinator {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = HomeViewModel()
        let viewController = HomeViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
    }
}
"""

private let homeViewControllerTemplate = """
import UIKit

final class HomeViewController: UIViewController {
    private let rootView = HomeView()
    private let viewModel: HomeViewModel

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
    }
}
"""

private let homeViewTemplate = """
import UIKit
import SnapKit

final class HomeView: UIView {
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        titleLabel.text = "Home"
        titleLabel.font = .preferredFont(forTextStyle: .largeTitle)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
"""

private let homeViewModelTemplate = """
import Foundation

final class HomeViewModel {
    let title = "Home"
}
"""

private let infoPlistTemplate = """
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleIdentifier</key>
    <string>{{bundleID}}</string>
    <key>UIApplicationSceneManifest</key>
    <dict>
        <key>UIApplicationSupportsMultipleScenes</key>
        <false/>
    </dict>
</dict>
</plist>
"""

private let testsTemplate = """
import XCTest
@testable import {{appName}}

final class {{appName}}Tests: XCTestCase {
    func testHomeTitle() {
        XCTAssertEqual(HomeViewModel().title, "Home")
    }
}
"""

private let pbxprojTemplate = """
// !$*UTF8*$!
{
    archiveVersion = 1;
    objectVersion = 56;
    classes = {};
    objects = {};
    rootObject = 000000000000000000000000;
}
"""

private let readmeTemplate = """
# {{appName}}

Generated by swift-get.

- Architecture: UIKit + MVVM + Coordinator
- Layout: SnapKit
- Deployment target: iOS 15+

The generated `.xcodeproj` is a minimal placeholder in this offline build. Replace `XcodeProjectEditor` with the XcodeProj-backed implementation when package dependencies are available.
"""
