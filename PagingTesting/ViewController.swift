//
//  ViewController.swift
//  PagingTesting
//
//  Created by Jacob Trentini on 8/2/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private let arrayOfColors:[UIColor] = [.green, .yellow, .red]
    private let arrayOfLocalities = ["San Francisco", "London", "Los Angelos"]
    private let arrayOfAQIs = [78, 101, 300]
    private let arrayOfDetails = ["Moderate", "Unhealthy for Sensitive Groups", "Very Unhealthy"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        setUpScrollView()
        
        pageControl.addTarget(self, action: #selector(pageControlDidChange(_:)), for: .valueChanged)
    }
    
    @objc private func pageControlDidChange(_ sender: UIPageControl) {
        let currentPage = sender.currentPage
        scrollView.setContentOffset(CGPoint(x: CGFloat(currentPage) * view.frame.size.width, y: 0), animated: true)
    }
    
    func setUpScrollView() {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(arrayOfLocalities.count), height: view.frame.height)
//        scrollView.isPagingEnabled = true
        for i in 0..<arrayOfLocalities.count {
            let subView = createNestedView(image: UIImage(systemName: "sensor.tag.radiowaves.forward")!,
                                           localityLabelString: "\(arrayOfLocalities[i])",
                                           aqiLabelString: "\(arrayOfAQIs[i])", detailLabelString: "\(arrayOfDetails[i])")
            
            subView.frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            subView.backgroundColor = arrayOfColors[i]
            scrollView.addSubview(subView)
        }
    }
    
    func createNestedView(image: UIImage, localityLabelString: String, aqiLabelString: String, detailLabelString: String) -> UIView {
        let outerView = UIView()
        let innerView = UIView()
        innerView.frame = CGRect(x: round(view.frame.width/5), y: round(view.frame.height/3), width: 200, height: 170)
        innerView.layer.cornerRadius = 10
        innerView.layer.masksToBounds = true
        innerView.layer.backgroundColor = UIColor.white.cgColor
        
        let imageView:UIImageView = {
            let imageView = UIImageView()
            imageView.image = image
            imageView.frame = CGRect(x: 20, y: 20, width: 30, height: 20)
            return imageView
        }()
        let localityLabel:UILabel = {
            let localityLabel = UILabel()
            localityLabel.text = localityLabelString
            localityLabel.frame = CGRect(x: 20, y: 50, width: 200, height: 20)
            return localityLabel
        }()
        let aqiLabel:UILabel = {
            let aqiLabel = UILabel()
            aqiLabel.text = aqiLabelString
            aqiLabel.frame = CGRect(x: 20, y: 80, width: 200, height: 40)
            if let roundedBodyDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).withDesign(.rounded) {
                aqiLabel.font = UIFont(descriptor: roundedBodyDescriptor, size: 35)
            }
            return aqiLabel
        }()
        let detailLabel:UILabel = {
            let detailLabel = UILabel()
            detailLabel.text = detailLabelString
            detailLabel.frame = CGRect(x: 20, y: 105, width: 200, height: 60)
            detailLabel.lineBreakMode = .byWordWrapping
            detailLabel.numberOfLines = 3
            return detailLabel
        }()
        let moreImageView: UIImageView = {
            let moreImageView = UIImageView()
            moreImageView.image = UIImage(systemName: "ellipsis.circle")
            moreImageView.frame = CGRect(x: innerView.frame.width-35, y: 20, width: 21, height: 20)
            return moreImageView
        }()
        
        innerView.addSubview(imageView)
        innerView.addSubview(localityLabel)
        innerView.addSubview(aqiLabel)
        innerView.addSubview(detailLabel)
        innerView.addSubview(moreImageView)
        outerView.addSubview(innerView)
        outerView.backgroundColor = .white
        return outerView
    }
}

extension ViewController : UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        print("scrollViewDidEndDecelerating")
    }
}

