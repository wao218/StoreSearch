//
//  MenuViewController.swift
//  StoreSearch
//
//  Created by Wesley Osborne on 12/30/20.
//

import UIKit

protocol MenuViewControllerDelegate: class {
  func menuViewControllerSendEmail(_ controller: MenuViewController)
}

class MenuViewController: UITableViewController {
  weak var delegate: MenuViewControllerDelegate?

  override func viewDidLoad() {
      super.viewDidLoad()
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    if indexPath.row == 0 {
      delegate?.menuViewControllerSendEmail(self)
    }
  }
  
} // End Of MenuViewController
