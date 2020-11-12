//
//  HomeViewController.swift
//  ProjetoGuilda
//
//  Created by Pedro Menezes on 27/10/20.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Class properties

    private var viewModel: HomeViewModel
    
    private var loading = UIActivityIndicatorView()
    
    // MARK: - Lyfe cicle
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "TELA INICIAL"
        self.configureTableView()
        DispatchQueue.main.async {
            self.viewModel.callSongs()
            self.toggleLoading(show: true)
        }
        loading.style = .large
        loading.tintColor = .blue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Class methods
    
    private func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerCell(TrackTableViewCell.className)
    }
    
    private func toggleLoading(show: Bool) {
        if(show) {
            DispatchQueue.main.async {
                self.loading.frame = self.tableView.frame
                self.view.addSubview(self.loading)
                self.loading.startAnimating()
            }
        } else {
            self.loading.removeFromSuperview()
            self.loading.stopAnimating()
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: TrackTableViewCell.className, for: indexPath) as? TrackTableViewCell
        let content = viewModel.cellContent(for: indexPath.row)
        cell?.passData(title: content)
        cell?.playPressed = { [weak self] in
            self?.viewModel.didClickPlayTrack(at: indexPath.row)
        }
        return cell ?? UITableViewCell()
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func error() {
        self.toggleLoading(show: false)
    }
    
    func success() {
        self.toggleLoading(show: false)
        self.tableView.reloadData()
    }
}
