//
//  MessageViewController.swift
//
//  Created by Manoj Karki on 9/25/17.
//

import UIKit
import RxSwift
import RxCocoa

//Messages View Controller that also shows messages delivered through push notification

class ResponseInfoViewController: BaseViewController, StoryboardInitializable {

    //MARK:- IBOutlets
    @IBOutlet weak var tableView: UITableView!

    //MARK:- View Model
    var viewModel = ResponseInfoViewModel()
    
    var coordinator : ScannerCoordinator?

    //MARK:- States

    var footerShown = false

    //MARK:- Vc Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150.0
        tableView.delegate = self
        tableView.dataSource = self

        self.addCancelBtn(sel: #selector(self.cancelButtonTapped))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc private func cancelButtonTapped() {
        print("Cancel button tapped")
        self.coordinator?.dissmissResponseInfoScreen()
    }
    

}

//MARK:- Tableview Delegate

extension ResponseInfoViewController: UITableViewDelegate {
       
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

    }
    
}

//MARK:- Tableview Datasource

extension ResponseInfoViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  viewModel.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath) as! DataCell
        let model = DataCellViewModel(response: viewModel.messageAtIndex(index: indexPath.row))
        cell.cellViewModel = model
        return cell
    }
}


