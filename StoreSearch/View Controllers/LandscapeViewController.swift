//
//  LandscapeViewController.swift
//  StoreSearch
//
//  Created by Wesley Osborne on 12/27/20.
//

import UIKit

class LandscapeViewController: UIViewController {
  @IBOutlet var scrollView: UIScrollView!
  @IBOutlet var pageControl: UIPageControl!
  
  private var firstTime = true
  var searchResults = [SearchResult]()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Removes contraints from main view
    view.removeConstraints(view.constraints)
    view.translatesAutoresizingMaskIntoConstraints = true
    // Removes contraints for page control
    pageControl.removeConstraints(pageControl.constraints)
    pageControl.translatesAutoresizingMaskIntoConstraints = true
    // Removes contraints for scroll view
    scrollView.removeConstraints(scrollView.constraints)
    scrollView.translatesAutoresizingMaskIntoConstraints = true
    
    view.backgroundColor = UIColor(patternImage: UIImage(named: "LandscapeBackground")!)
    
    pageControl.numberOfPages = 0
    
  }
  

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    let safeFrame = view.safeAreaLayoutGuide.layoutFrame
    scrollView.frame = safeFrame
    pageControl.frame = CGRect(
      x: safeFrame.origin.x,
      y: safeFrame.size.height - pageControl.frame.size.height,
      width: safeFrame.size.width,
      height: pageControl.frame.size.height
    )
    
    if firstTime {
      firstTime = false
      titleButtons(searchResults)
    }
  }
  
  // MARK: - Actions
  @IBAction func pageChanged(_ sender: UIPageControl) {
    UIView.animate(
      withDuration: 0.3,
      delay: 0,
      options: [.curveEaseInOut],
      animations: {
      self.scrollView.contentOffset = CGPoint(
        x: self.scrollView.bounds.size.width * CGFloat(sender.currentPage),
        y: 0
      )
    },
      completion: nil)
  }
  
  // MARK: - Private Methods
  private func titleButtons(_ searchResults: [SearchResult]) {
    let itemWidth: CGFloat = 94
    let itemHeight: CGFloat = 88
    var columnsPerPage = 0
    var rowsPerPage = 0
    var marginX: CGFloat = 0
    var marginY: CGFloat = 0
    let viewWidth = scrollView.bounds.size.width
    let viewHeight = scrollView.bounds.size.height
    
    columnsPerPage = Int(viewWidth / itemWidth)
    rowsPerPage = Int(viewHeight / itemHeight)
    
    marginX = (viewWidth - (CGFloat(columnsPerPage) * itemWidth)) * 0.5
    marginY = (viewHeight - (CGFloat(rowsPerPage) * itemHeight)) * 0.5
    
    // Button size
    let buttonWidth: CGFloat = 82
    let buttonHeight: CGFloat = 82
    let paddingHorz = (itemWidth - buttonWidth) / 2
    let paddingVert = (itemHeight - buttonHeight) / 2
    
    // Add the buttons
    var row = 0
    var column = 0
    var x = marginX
    for (index, result) in searchResults.enumerated() {
      let button = UIButton(type: .system)
      button.backgroundColor = UIColor.white
      button.setTitle("\(index)", for: .normal)
      button.frame = CGRect(
        x: x + paddingHorz,
        y: marginY + CGFloat(row) * itemHeight + paddingVert,
        width: buttonWidth,
        height: buttonHeight
      )
      scrollView.addSubview(button)
      row += 1
      if row == rowsPerPage {
        row = 0
        x += itemWidth
        column += 1
        if column == columnsPerPage {
          column = 0
          x += marginX * 2
        }
      }
    }
    
    // Set scroll view content size
    let buttonsPerPage = columnsPerPage * rowsPerPage
    let numPages = 1 + (searchResults.count - 1) / buttonsPerPage
    scrollView.contentSize = CGSize(
      width: CGFloat(numPages) * viewWidth,
      height: scrollView.bounds.size.height
    )
    print("Number of pages: \(numPages)")
    pageControl.numberOfPages = numPages
    pageControl.currentPage = 0
  }
} // End Of LandscapeViewController Class

extension LandscapeViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let width = scrollView.bounds.size.width
    let page = Int((scrollView.contentOffset.x + width / 2) / width)
    pageControl.currentPage = page
  }
}
