//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Wesley Osborne on 12/26/20.
//

import UIKit

class DetailViewController: UIViewController {
  @IBOutlet var popupView: UIView!
  @IBOutlet var artworkImageView: UIImageView!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var artistNameLabel: UILabel!
  @IBOutlet var kindLabel: UILabel!
  @IBOutlet var genreLabel: UILabel!
  @IBOutlet var priceButton: UIButton!
  
  var searchResult: SearchResult!
  var downloadTask: URLSessionDownloadTask?
  
  enum AnimationStyle {
    case slide
    case fade
  }
  
  var dismissStyle = AnimationStyle.fade

  override func viewDidLoad() {
    super.viewDidLoad()
    popupView.layer.cornerRadius = 10
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(close))
    gestureRecognizer.cancelsTouchesInView = false
    gestureRecognizer.delegate = self
    view.addGestureRecognizer(gestureRecognizer)
    
    if searchResult != nil {
      updateUI()
    }
    
    // Gradient View
    view.backgroundColor = UIColor.clear
    let dimmingView = GradientView(frame: CGRect.zero)
    dimmingView.frame = view.bounds
    view.insertSubview(dimmingView, at: 0)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    transitioningDelegate = self
  }
  
  // MARK: - Actions
  @IBAction func close() {
    dismissStyle = .slide
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func openInStore() {
    if let url = URL(string: searchResult.storeURL) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
  }
  
  // MARK: - Helper Method
  func updateUI() {
    nameLabel.text = searchResult.name
    
    if searchResult.artist.isEmpty {
      artistNameLabel.text = NSLocalizedString("Uknown", comment: "Artist name label: Unknown")
    } else {
      artistNameLabel.text = searchResult.artist
    }
    
    kindLabel.text = searchResult.type
    genreLabel.text = searchResult.genre
    
    // Show price
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = searchResult.currency
    
    let priceText: String
    if searchResult.price == 0 {
      priceText = NSLocalizedString("Free", comment: "Price text: Free")
    } else if let text = formatter.string(from: searchResult.price as NSNumber) {
      priceText = text
    } else {
      priceText = ""
    }
    
    priceButton.setTitle(priceText, for: .normal)
    
    if let largeURL = URL(string: searchResult.imageLarge) {
      downloadTask = artworkImageView.loadImage(url: largeURL)
    }
  }
  
  deinit {
    print("deinit \(self)")
    downloadTask?.cancel()
  }
  
} // End Of DetailViewController Class

extension DetailViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    return (touch.view === self.view)
  }
}

extension DetailViewController: UIViewControllerTransitioningDelegate {
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      return BounceAnimationController()
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    switch dismissStyle {
    case .slide:
      return SlideOutAnimationController()
    case .fade:
      return FadeOutAnimationController()
    }
  }
}
