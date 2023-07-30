import UIKit

class HomeViewController: UIViewController {
    // MARK: - Properties

    var filterOptions: FilterOptions?

    private lazy var logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logoLight")
        return imageView
    }()

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        return view
    }()

    private let containerView = UIView()

    private var genderSelector: GenderSelector!
    private var firstBanner: FirstBanner!
    private var secondBanner: SecondBanner!
    private var firstCategoryBanner: CategoryBanner!
    private var secondCategoryBanner: CategoryBanner!

    private let stackView = UIStackView()

    private lazy var spacerView: UIView = {
        let spacerView = UIView()
        spacerView.backgroundColor = .clear
        return spacerView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }

    // MARK: - Setup UI

    private func setupUI() {
        view.backgroundColor = .systemBackground

        // Logo
        logo.activateAutoLayout()
        view.addSubview(logo)
        NSLayoutConstraint.activate([
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 10)
        ])

        guard let filterOptions = filterOptions else { return }

        // Gender Selector

        genderSelector = GenderSelector(filterOptions)
        genderSelector.delegate = self
        genderSelector.activateAutoLayout()
        view.addSubview(genderSelector)
        NSLayoutConstraint.activate([
            genderSelector.topAnchor.constraint(equalToSystemSpacingBelow: logo.bottomAnchor, multiplier: 2.5),
            genderSelector.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: genderSelector.trailingAnchor, multiplier: 2),
            genderSelector.heightAnchor.constraint(equalToConstant: 48)
        ])

        // Scroll View
        scrollView.activateAutoLayout()
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalToSystemSpacingBelow: genderSelector.bottomAnchor, multiplier: 3),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        // Container View
        containerView.activateAutoLayout()
        scrollView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])

        // First Banner
        firstBanner = FirstBanner(filterOptions)
        firstBanner.delegate = self
        firstBanner.activateAutoLayout()
        containerView.addSubview(firstBanner)
        NSLayoutConstraint.activate([
            firstBanner.topAnchor.constraint(equalTo: containerView.topAnchor),
            firstBanner.leadingAnchor.constraint(equalToSystemSpacingAfter: containerView.leadingAnchor, multiplier: 2),
            containerView.trailingAnchor.constraint(equalToSystemSpacingAfter: firstBanner.trailingAnchor, multiplier: 2),
            firstBanner.heightAnchor.constraint(equalToConstant: 190)
        ])

        // Second Banner
        secondBanner = SecondBanner(filterOptions)
        secondBanner.delegate = self
        secondBanner.activateAutoLayout()
        containerView.addSubview(secondBanner)
        NSLayoutConstraint.activate([
            secondBanner.topAnchor.constraint(equalToSystemSpacingBelow: firstBanner.bottomAnchor, multiplier: 3),
            secondBanner.leadingAnchor.constraint(equalToSystemSpacingAfter: containerView.leadingAnchor, multiplier: 2),
            containerView.trailingAnchor.constraint(equalToSystemSpacingAfter: secondBanner.trailingAnchor, multiplier: 2),
            secondBanner.heightAnchor.constraint(equalToConstant: 190)
        ])

        // Stack View
        stackView.activateAutoLayout()
        containerView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: secondBanner.bottomAnchor, multiplier: 3),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: containerView.leadingAnchor, multiplier: 2),
            containerView.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 2)
        ])

        // Spacer View
        spacerView.activateAutoLayout()
        containerView.addSubview(spacerView)
        NSLayoutConstraint.activate([
            spacerView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            spacerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            spacerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            spacerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        stackView.spacing = 20
        stackView.distribution = .fillEqually

        // Category Banners
        firstCategoryBanner = CategoryBanner()
        firstCategoryBanner.delegate = self
        secondCategoryBanner = CategoryBanner()
        secondCategoryBanner.delegate = self
        stackView.addArrangedSubview(firstCategoryBanner)
        stackView.addArrangedSubview(secondCategoryBanner)

        scrollView.contentSize = containerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

        // Update the UI with the current filterOptions value
        updateUI()
    }

    // MARK: - Update UI

    private func updateUI() {
        guard let filterOptions = filterOptions else { return }

        genderSelector.update(with: filterOptions)
        firstBanner.update(with: filterOptions)
        secondBanner.update(with: filterOptions)

        if filterOptions.gender == .boys {
            firstCategoryBanner.update(withImage: UIImage(named: "66"), andTitle: "Suits")
            secondCategoryBanner.update(withImage: UIImage(named: "667"), andTitle: "Jackets")
        }
        else {
            firstCategoryBanner.update(withImage: UIImage(named: "35"), andTitle: "Skirts")
            secondCategoryBanner.update(withImage: UIImage(named: "36"), andTitle: "Jackets")
        }

        // Refresh the layout if needed
        view.setNeedsLayout()
    }
}

// MARK: - GenderSelectorDelegate

extension HomeViewController: GenderSelectorDelegate {
    func genderSelectorDidChange() {
        guard let filterOptions = filterOptions else { return }
        filterOptions.gender = filterOptions.gender == .boys ? .girls : .boys

        updateUI()
    }
}

// MARK: -  FirstBannerDelegate

extension HomeViewController: FirstBannerDelegate {
    func firstBannerTapped() {
        if let tabBarController = tabBarController {
            tabBarController.selectedIndex = 1
        }
    }
}

// MARK: -  SecondBannerDelegate

extension HomeViewController: SecondBannerDelegate {
    func secondBannerTapped() {
        if let tabBarController = tabBarController {
            filterOptions?.directory = "activewear"
            tabBarController.selectedIndex = 1
        }
    }
}

// MARK: -  SecondBannerDelegate

extension HomeViewController: CategoryBannerDelegate {
    func CategoryBannerTapped(_ directory: String) {
        if let tabBarController = tabBarController {
            filterOptions?.directory = directory
            tabBarController.selectedIndex = 1
        }
    }
}
