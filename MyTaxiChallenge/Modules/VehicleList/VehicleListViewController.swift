//
//  VehicleListViewController.swift
//  MyTaxiChallenge
//
//  Created by Ricardo Abel Martinez Vivanco on 7/17/18.
//  Copyright © 2018 Ricardo Abel Martinez Vivanco. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class VehicleListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var activityIndicator: NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRect.zero)
    
    lazy var viewModel: VehicleListViewModel = {
        return VehicleListViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "VehicleTableViewCell", bundle: nil), forCellReuseIdentifier: "vehicleTableViewCell")
        configureActivityIndicator()
        initViewModel()
    }
    
    private func configureActivityIndicator() {
        let frame = CGRect(x: view.center.x, y: view.center.y, width: 100, height: 100)
        activityIndicator = NVActivityIndicatorView(frame: frame, type: .pacman, color: UIColor.yellow)
        activityIndicator.center = CGPoint(x: view.center.x, y: view.center.y)
        activityIndicator.isHidden = true
        view.addSubview(activityIndicator)
    }

    private func initViewModel() {
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                if let message = strongSelf.viewModel.alertMessage {
                    strongSelf.showAlert( message )
                }
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                let isLoading = strongSelf.viewModel.isLoading
                if isLoading {
                    strongSelf.activityIndicator.isHidden = false
                    strongSelf.activityIndicator.startAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        strongSelf.tableView.alpha = 0.0
                    })
                }else {
                    strongSelf.activityIndicator.isHidden = true
                    strongSelf.activityIndicator.stopAnimating()
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        strongSelf.tableView.alpha = 1.0
                    })
                }
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.tableView.reloadData()
            }
        }
        
        viewModel.getVehicles()
    }
    
    private func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension VehicleListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "vehicleTableViewCell", for: indexPath) as! VehicleTableViewCell
        
        cell.congfigureWithVehicle(info: viewModel.getCellViewModel(at: indexPath))
        // Configure the cell...
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }

}
