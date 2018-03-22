//
//  ViewController.swift
//  InstaPage
//
//  Created by Felix Hedlund on 2018-03-21.
//  Copyright © 2018 Jayway AB. All rights reserved.
//

import UIKit

protocol TableViewDelegate{
    func setupScroll(for tableView: UITableView)
}

class ViewController: UIViewController, InstaPageDelegate, TableViewDelegate, UIScrollViewDelegate, UITableViewDelegate {
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var selectionView: UIView!
    @IBOutlet weak var selectionViewHorizontalConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    var pager: InstaPageViewController!
    var allowTableViewScroll = false
    
    var tableViews = [UITableView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.bounces = false
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func setupScroll(for tableView: UITableView) {
        tableView.delegate = self
        tableView.isScrollEnabled = allowTableViewScroll
        tableViews.append(tableView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            for tableView in tableViews{
                tableView.isScrollEnabled = self.scrollView.contentOffset.y >= 128
            }
        }else{
            for tableView in tableViews{
                if tableView == scrollView{
                    tableView.isScrollEnabled = tableView.contentOffset.y > 0
                }else{
                    tableView.scrollRectToVisible(CGRect(x: 1, y: 1, width: 1, height: 1), animated: false)
                }
            }
        }
    }
    
    @IBAction func didPressButton(_ sender: UIButton) {
        changeViewControllers(sender: sender, didScroll: false)
    }
    
    func changeViewControllers(sender: UIButton, didScroll: Bool){
        var index = 0
        var direction: UIPageViewControllerNavigationDirection?
        for button in buttons{
            if sender == button{
                selectionViewHorizontalConstraint.isActive = false
                let constraint = NSLayoutConstraint(item: selectionView, attribute: .centerX, relatedBy: .equal, toItem: button, attribute: .centerX, multiplier: 1, constant: 0)
                constraint.isActive = true
                selectionViewHorizontalConstraint = constraint
                
                if pager.currentIndex < index{
                    direction = .forward
                }else if pager.currentIndex > index{
                    direction = .reverse
                }
                
                pager.currentIndex = index
            }
            index += 1
        }
        
        if let dir = direction, !didScroll{
            self.pager.setViewControllers([pager.pages[pager.currentIndex]], direction: dir, animated: true, completion: { (completion) in
                
            })
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func changeToIndex(index: Int) {
        self.changeViewControllers(sender: buttons[index], didScroll: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if let vc = segue.destination as? InstaPageViewController{
            self.pager = vc
            vc.instaDelegate = self
            vc.tableViewDelegate = self
        }
     }
 
    
    


}

