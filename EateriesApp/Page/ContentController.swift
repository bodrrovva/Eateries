//
//  ContentController.swift
//  Eateries
//
//  Created by admin on 24.08.2022.
//

import UIKit

class ContentController: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var subheaderLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageButton: UIButton!
    
    @IBAction func pageButtonPressed(_ sender: Any) {
        switch index {
        case 0:
            let pageVC = parent as! PageController
            pageVC.nextVC(atIndex: index)
        case 1:
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "tabBar") as! TabBar
            self.present(nextVC, animated: true, completion: nil)
        default:
            break
        }
    }
    var header = ""
    var subheader = ""
    var imageFile = ""
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageButton.layer.cornerRadius = 15
        pageButton.clipsToBounds = true
        pageButton.backgroundColor = UIColor(named: "Green")
        pageButton.tintColor = UIColor.white
        
        switch index {
        case 0: pageButton.setTitle("Next", for: .normal)
        case 1: pageButton.setTitle("Open", for: .normal)
        default:
            break
        }
        
        headerLabel.text = header
        subheaderLabel.text = subheader
        imageView.image = UIImage(named: imageFile)
        pageControl.numberOfPages = 2
        pageControl.currentPage = index
    }
    
}
