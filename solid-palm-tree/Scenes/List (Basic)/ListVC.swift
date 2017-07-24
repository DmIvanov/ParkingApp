//
//  ListVC.swift
//  solid-palm-tree
//
//  Created by Dmitrii on 21/07/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import UIKit

class ListVC: UIViewController {

    let cellId = "ListCell"
    let inputCellId = "ListInputCell"

    // MARK: - Properties
    var dataSource: ListVCDataSource!
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var topLabel: UILabel!
    @IBOutlet private var bottomButton: UIButton!

    private var tapRecognizer: UITapGestureRecognizer?


    // MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dataSource.vcViewDidAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dataSource.vcViewWillDisappear()
    }

    // MARK: - Public
    func refreshUI() {
        topLabel.text = dataSource.topLabelText()
        if dataSource.bottomButtonText() != nil {
            bottomButton.setTitle(dataSource.bottomButtonText(), for: .normal)
        } else {
            bottomButton.isHidden = true
        }
        tableView.reloadData()
        if dataSource.inputMode() {
            tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
            view.addGestureRecognizer(tapRecognizer!)
        } else {
            if tapRecognizer != nil {
                view.removeGestureRecognizer(tapRecognizer!)
                tapRecognizer = nil
            }
        }
    }


    // MARK: - Private
    private func resetLabels() {

    }


    // MARK: - Actions
    @IBAction func bottomButtonPressed() {
        dataSource.bottomButtonPressed()
    }

    func viewTapped() {
        view.endEditing(true)
        if dataSource.inputMode() {
            let cellls = tableView.visibleCells
            var cellsData = [(String, String)]()
            for cell in cellls {
                let inputCell = cell as! ListInputCell
                cellsData.append((inputCell.titileLabel.text!, inputCell.textField.text!))
            }
            dataSource.passInputData(data: cellsData)
        }
    }
}


extension ListVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.cellsAmount()
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if dataSource.inputMode() {
            let cell = tableView.dequeueReusableCell(withIdentifier: inputCellId)! as! ListInputCell
            if let model = dataSource.cellModel(index: indexPath.row) {
                cell.titileLabel.text = model.title
                cell.textField.placeholder = model.subtitle
            }
            return cell;
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId)!
            if let model = dataSource.cellModel(index: indexPath.row) {
                cell.textLabel?.text = model.title
                cell.detailTextLabel?.text = model.subtitle
            }
            return cell;
        }
    }
}


extension ListVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataSource.cellSelected(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


protocol ListVCDataSource {

    // Calls
    func cellSelected(index: Int)
    func bottomButtonPressed()
    func vcViewDidAppear()
    func vcViewWillDisappear()
    func passInputData(data: [(String, String)])

    // Getters
    func topLabelText() -> String
    func bottomButtonText() -> String?
    func cellModel(index: Int) -> ListVCCellModel?
    func cellsAmount() -> Int
    func inputMode() -> Bool
}

extension ListVCDataSource {

    // Calls
    func cellSelected(index: Int) {}
    func bottomButtonPressed() {}
    func vcViewDidAppear() {}
    func vcViewWillDisappear() {}
    func passInputData(data: [(String, String)]) {}

    // Getters
    func topLabelText() -> String {return ""}
    func bottomButtonText() -> String? {return nil}
    func cellModel(index: Int) -> ListVCCellModel? {return nil}
    func cellsAmount() -> Int {return 0}
    func inputMode() -> Bool {return false}
}
