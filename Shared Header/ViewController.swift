//
//  ViewController.swift
//  Shared Header
//
//  Created by Will Battel on 2/24/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet var headerViewTopConstraint: NSLayoutConstraint?
    @IBOutlet weak var horizontalPageControlView: UIView!
    @IBOutlet weak var catsButton: UIButton!
    @IBOutlet weak var dogsButton: UIButton!
    
    @IBOutlet weak var widgetsCollectionView: UICollectionView!
    var widgetsDataSource: UICollectionViewDiffableDataSource<WidgetsSection, WidgetsItem>?
    
    @IBOutlet weak var horizontalScrollView: UIScrollView!
    
    weak var presentedScrollView: UIScrollView? {
        didSet {
            if let oldValue = oldValue {
                if oldValue === presentedScrollView {
                    return
                }
                view.removeGestureRecognizer(oldValue.panGestureRecognizer)
            }
            guard let presentedScrollView = presentedScrollView else {
                return
            }
            view.addGestureRecognizer(presentedScrollView.panGestureRecognizer)
            if presentedScrollView === catsCollectionView {
                catsButton.isSelected = true
                dogsButton.isSelected = false
            }
            else {
                catsButton.isSelected = false
                dogsButton.isSelected = true
            }
        }
    }
    
    @IBOutlet weak var catsCollectionView: UICollectionView!
    @IBOutlet weak var dogsCollectionView: UICollectionView!
    
    var catsDataSource: UICollectionViewDiffableDataSource<CatsSection, CatsItem>?
    var dogsDataSource: UICollectionViewDiffableDataSource<DogsSection, DogsItem>?
    
    var didSetupdogsCollectionView = false
    
    enum WidgetsSection: Hashable {
        case widgets
    }
    
    enum WidgetsItem: Hashable {
        case widget(Widget)
    }
    
    enum CatsSection: Hashable {
        case header
        case cats
    }
    
    enum CatsItem: Hashable {
        case header
        case cat(Cat)
    }
    
    enum DogsSection: Hashable {
        case header
        case dogs
    }
    
    enum DogsItem: Hashable {
        case header
        case dog(Dog)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        horizontalScrollView.delegate = self
        
        headerView.delegate = self
        
        catsCollectionView.delegate = self
        dogsCollectionView.delegate = self
        
        catsCollectionView.refreshControl = UIRefreshControl()
        catsCollectionView.refreshControl?.addTarget(self, action: #selector(onRefreshCats), for: .valueChanged)
        dogsCollectionView.refreshControl = UIRefreshControl()
        dogsCollectionView.refreshControl?.addTarget(self, action: #selector(onRefreshDogs), for: .valueChanged)
        
        presentedScrollView = catsCollectionView
        
        setupWidgetsCollectionView()
        setupCatsCollectionView()
        // Wait to call setupDogsCollectionView until presenting
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // Correct misaligned views
        coordinator.animateAlongsideTransition(in: view, animation: nil) { _ in
            if let presentedScrollView = self.presentedScrollView {
                self.horizontalScrollView.scrollRectToVisible(presentedScrollView.frame, animated: true)
                self.headerViewTopConstraint?.constant = max(
                    presentedScrollView.frame.minY - presentedScrollView.contentOffset.y,
                    self.horizontalPageControlView.frame.height - self.headerView.frame.height)
            }
        }
    }
    
    @objc func onRefreshCats() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.catsCollectionView.refreshControl?.endRefreshing()
        }
    }
    
    @objc func onRefreshDogs() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.dogsCollectionView.refreshControl?.endRefreshing()
        }
    }
    
    func setupWidgetsCollectionView() {
        widgetsCollectionView.contentInset = .init(top: 0, left: 8, bottom: 0, right: 8)
        widgetsCollectionView.collectionViewLayout = createWidgetsLayout()
        configureWidgetsDataSource()
    }
    
    func setupCatsCollectionView() {
        catsCollectionView.collectionViewLayout = createCatsLayout()
        configureCatsDataSource()
    }
    
    func setupDogsCollectionView() {
        guard !didSetupdogsCollectionView else {
            return
        }
        didSetupdogsCollectionView = true
        dogsCollectionView.collectionViewLayout = createDogsLayout()
        configureDogsDataSource()
    }
    
    func createWidgetsLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let widgetItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(1.0)))
            let widgetsGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalHeight(1.0),
                                                   heightDimension: .fractionalHeight(1.0)),
                subitems: [widgetItem])
            let widgetsSection = NSCollectionLayoutSection(group: widgetsGroup)
            widgetsSection.interGroupSpacing = 8
            return widgetsSection
        }, configuration: config)
        return layout
    }
    
    func createCatsLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [unowned self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                let headerItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(self.headerView.bounds.height)))
                let headerGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(self.headerView.bounds.height)),
                    subitems: [headerItem])
                let headerSection = NSCollectionLayoutSection(group: headerGroup)
                return headerSection
            case 1:
                let catItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0)))
                let catsGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(400)),
                    subitems: [catItem])
                let catsSection = NSCollectionLayoutSection(group: catsGroup)
                return catsSection
            default:
                return nil
            }
        }
        return layout
    }
    
    func createDogsLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [unowned self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                let headerItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(self.headerView.bounds.height)))
                let headerGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(self.headerView.bounds.height)),
                    subitems: [headerItem])
                let headerSection = NSCollectionLayoutSection(group: headerGroup)
                return headerSection
            case 1:
                let dogItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0)))
                let dogsGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(100)),
                    subitems: [dogItem])
                let dogsSection = NSCollectionLayoutSection(group: dogsGroup)
                return dogsSection
            default:
                return nil
            }
        }
        return layout
    }
    
    func configureWidgetsDataSource() {
        let dataSource = UICollectionViewDiffableDataSource<WidgetsSection, WidgetsItem>(collectionView: widgetsCollectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .widget(let widget):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "widget", for: indexPath)
                guard let widgetCell = cell as? WidgetCollectionViewCell else {
                    return cell
                }
                widgetCell.backgroundColor = widget.color
                return widgetCell
            }
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<WidgetsSection, WidgetsItem>()
        snapshot.appendSections([.widgets])
        snapshot.appendItems(Data.widgets.map({ WidgetsItem.widget($0) }), toSection: .widgets)
        dataSource.apply(snapshot, animatingDifferences: false)
        widgetsDataSource = dataSource
    }
    
    func configureCatsDataSource() {
        let dataSource = UICollectionViewDiffableDataSource<CatsSection, CatsItem>(collectionView: catsCollectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .header:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "header", for: indexPath)
                guard let emptyCell = cell as? EmptyCollectionViewCell else {
                    return cell
                }
                emptyCell.backgroundColor = .systemTeal
                return cell
            case .cat(let cat):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cat", for: indexPath)
                guard let catCell = cell as? CatCollectionViewCell else {
                    return cell
                }
                catCell.backgroundColor = cat.color
                catCell.idLabel.text = cat.id
                return catCell
            }
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<CatsSection, CatsItem>()
        snapshot.appendSections([.header, .cats])
        snapshot.appendItems([.header], toSection: .header)
        snapshot.appendItems(Data.cats.map({ CatsItem.cat($0) }), toSection: .cats)
        dataSource.apply(snapshot, animatingDifferences: false)
        catsDataSource = dataSource
    }
    
    func configureDogsDataSource() {
        let dataSource = UICollectionViewDiffableDataSource<DogsSection, DogsItem>(collectionView: dogsCollectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .header:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "header", for: indexPath)
                guard let emptyCell = cell as? EmptyCollectionViewCell else {
                    return cell
                }
                emptyCell.backgroundColor = .systemTeal
                return cell
            case .dog(let dog):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dog", for: indexPath)
                guard let dogCell = cell as? DogCollectionViewCell else {
                    return cell
                }
                dogCell.backgroundColor = dog.color
                dogCell.idLabel.text = dog.id
                return dogCell
            }
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<DogsSection, DogsItem>()
        snapshot.appendSections([.header, .dogs])
        snapshot.appendItems([.header], toSection: .header)
        snapshot.appendItems(Data.dogs.map({ DogsItem.dog($0) }), toSection: .dogs)
        dataSource.apply(snapshot, animatingDifferences: false)
        dogsDataSource = dataSource
    }
    
    @IBAction func catsButtonPressed() {
        horizontalScrollView.scrollRectToVisible(catsCollectionView.frame, animated: true)
    }
    
    @IBAction func dogsButtonPressed() {
        horizontalScrollView.scrollRectToVisible(dogsCollectionView.frame, animated: true)
    }

}

extension ViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView === horizontalScrollView {
            if horizontalScrollView.contentOffset.x > 0 {
                setupDogsCollectionView()
            }
            
            let distanceCatsCV = abs(horizontalScrollView.contentOffset.x - catsCollectionView.frame.minX)
            let distanceDogsCV = abs(horizontalScrollView.contentOffset.x - dogsCollectionView.frame.minX)
            
            if distanceCatsCV < distanceDogsCV {
                presentedScrollView = catsCollectionView
            }
            else {
                presentedScrollView = dogsCollectionView
            }
        }
        else if scrollView === catsCollectionView || scrollView === dogsCollectionView {
            // Update header position
            headerViewTopConstraint?.constant = max(
                scrollView.frame.minY - scrollView.contentOffset.y,
                horizontalPageControlView.frame.height - headerView.frame.height)
            
            // Update other scroll view(s) to match header position
            if scrollView.contentOffset.y < (headerView.frame.height - horizontalPageControlView.frame.height) {
                if scrollView === catsCollectionView {
                    dogsCollectionView.contentOffset = catsCollectionView.contentOffset
                }
                else {
                    catsCollectionView.contentOffset = dogsCollectionView.contentOffset
                }
            }
            else {
                if scrollView === catsCollectionView {
                    if dogsCollectionView.contentOffset.y < (headerView.frame.height - horizontalPageControlView.frame.height) {
                        dogsCollectionView.contentOffset = CGPoint(x: 0, y: headerView.frame.height - horizontalPageControlView.frame.height)
                    }
                }
                else {
                    if catsCollectionView.contentOffset.y < (headerView.frame.height - horizontalPageControlView.frame.height) {
                        catsCollectionView.contentOffset = CGPoint(x: 0, y: headerView.frame.height - horizontalPageControlView.frame.height)
                    }
                }
            }
        }
    }
    
}

extension ViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer === widgetsCollectionView.panGestureRecognizer {
            return true
        }
        return false
    }

}

extension ViewController: HeaderViewDelegate {
    
    func headerView(_ headerView: HeaderView, heightDidChangeTo newHeight: CGFloat) {
        catsCollectionView.collectionViewLayout.invalidateLayout()
        dogsCollectionView.collectionViewLayout.invalidateLayout()
    }
    
}

protocol HeaderViewDelegate: AnyObject {
    func headerView(_ headerView: HeaderView, heightDidChangeTo newHeight: CGFloat)
}

class HeaderView: UIStackView {
    
    weak var delegate: HeaderViewDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        delegate?.headerView(self, heightDidChangeTo: bounds.height)
    }
    
}
