import Foundation

public struct ModuleScaffolder {
    private let renderer = TemplateRenderer()

    public init() {}

    public func planModule(context: ModuleTemplateContext) throws -> ScaffoldPlan {
        try NameValidator.validateTypeName(context.name)

        let values = ["moduleName": context.name]
        var templates = [
            PlannedFile(relativePath: "{{moduleName}}/{{moduleName}}ViewController.swift", contents: viewControllerTemplate),
            PlannedFile(relativePath: "{{moduleName}}/{{moduleName}}View.swift", contents: viewTemplate),
            PlannedFile(relativePath: "{{moduleName}}/{{moduleName}}ViewModel.swift", contents: viewModelTemplate),
            PlannedFile(relativePath: "{{moduleName}}/{{moduleName}}Coordinator.swift", contents: coordinatorTemplate)
        ]

        if context.includeService {
            templates.append(PlannedFile(relativePath: "{{moduleName}}/{{moduleName}}Service.swift", contents: serviceTemplate))
        }

        let files = try templates.map { template in
            PlannedFile(
                relativePath: try renderer.render(template.relativePath, values: values),
                contents: try renderer.render(template.contents, values: values)
            )
        }

        return ScaffoldPlan(root: context.destination, files: files)
    }
}

private let viewControllerTemplate = """
import UIKit

final class {{moduleName}}ViewController: UIViewController {
    private let rootView = {{moduleName}}View()
    private let viewModel: {{moduleName}}ViewModel

    init(viewModel: {{moduleName}}ViewModel) {
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

private let viewTemplate = """
import UIKit
import SnapKit

final class {{moduleName}}View: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
"""

private let viewModelTemplate = """
import Foundation

final class {{moduleName}}ViewModel {
    let title = "{{moduleName}}"
}
"""

private let coordinatorTemplate = """
import UIKit

final class {{moduleName}}Coordinator: Coordinator {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = {{moduleName}}ViewModel()
        let viewController = {{moduleName}}ViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
"""

private let serviceTemplate = """
import Foundation

protocol {{moduleName}}Servicing {}

final class {{moduleName}}Service: {{moduleName}}Servicing {}
"""
