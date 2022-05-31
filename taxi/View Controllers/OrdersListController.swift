//
//  OrdersController.swift
//  taxi
//
//  Created by Viacheslav Yakymenko on 23.05.2022.
//

import UIKit
import RxSwift
import RxCocoa

class OrdersListController: UIViewController {
    
    let bag = DisposeBag()
    private var collectionView: UICollectionView?
    private var spinner = UIActivityIndicatorView()
    private let refreshControl = UIRefreshControl()

    private var viewModel: OrdersViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Заказы"
        navigationController?.navigationBar.prefersLargeTitles = false
        view.backgroundColor = .white
        viewModel = OrdersListViewModel()
        bind()
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInsetReference = .fromSafeArea
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionView ?? UICollectionView())
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(OrderCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        spinner.hidesWhenStopped = true
        collectionView?.addSubview(spinner)
        
        if #available(iOS 10.0, *) {
            collectionView?.refreshControl = refreshControl
        } else {
            collectionView?.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        collectionView?.alwaysBounceVertical = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        spinner.center = CGPoint(x: self.view.center.x, y: 16 + (self.navigationController?.navigationBar.frame.height ?? 0))
        
        collectionView?.frame = getSafeArea()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    private func bind() {
        viewModel?.orders.asDriver().drive(onNext: { [weak self] _ in
            self?.collectionView?.refreshControl?.endRefreshing()
            self?.spinner.stopAnimating()
            self?.collectionView?.reloadData()
        }).disposed(by: bag)
    }
    
    @objc private func refreshData(_ sender: Any) {
        DispatchQueue.main.async {
            self.collectionView?.refreshControl?.beginRefreshing()
        }
        updateUI()
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            if !(self.collectionView?.refreshControl?.isRefreshing ?? false) {
                self.spinner.startAnimating()
            } else {
                self.collectionView?.refreshControl?.beginRefreshing()
            }
        }
        guard let viewModel = viewModel else {
            return
        }
        viewModel.fetchData()
    }
}
 
//MARK: - Collection view data source & delegate
extension OrdersListController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.orderCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! OrderCell
        let cellViewModel = viewModel?.cellViewModel(for: indexPath.row)
        cell.viewModel = cellViewModel
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bottomSheetController = OrderDetailController()
        bottomSheetController.viewModel = viewModel?.detailsViewModel(for: indexPath.row)
        bottomSheetController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(bottomSheetController, animated: true)
    }
    
}

//MARK: - Collection view layout
extension OrdersListController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.width - 32, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    }
    
}

extension UIViewController {
    func getSafeArea() -> CGRect {
        let topSafeArea: CGFloat
        let bottomSafeArea: CGFloat
        let leftSafeArea: CGFloat
        let rightSafeArea: CGFloat

        if #available(iOS 11.0, *) {
            topSafeArea = view.safeAreaInsets.top
            bottomSafeArea = view.safeAreaInsets.bottom
            leftSafeArea = view.safeAreaInsets.left
            rightSafeArea = view.safeAreaInsets.right
        } else {
            topSafeArea = topLayoutGuide.length
            bottomSafeArea = bottomLayoutGuide.length
            leftSafeArea = topLayoutGuide.length
            rightSafeArea = bottomLayoutGuide.length
        }
        return CGRect(x: leftSafeArea, y: topSafeArea , width: view.bounds.width - leftSafeArea - rightSafeArea, height: view.bounds.height - topSafeArea - bottomSafeArea)
    }
}
