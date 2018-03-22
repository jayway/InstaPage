//
//  ViewController.swift
//  InstaPage
//
//  Created by Felix Hedlund on 2018-03-21.
//  Copyright © 2018 Jayway AB. All rights reserved.
//

import UIKit

protocol TableViewDelegate{
    func updateBottomConstraint(for tableView: UITableView)
}

class ViewController: UIViewController, InstaPageDelegate, TableViewDelegate, UIScrollViewDelegate, UITableViewDelegate {
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var selectionView: UIView!
    @IBOutlet weak var selectionViewHorizontalConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var containerConstraint: NSLayoutConstraint!
    
    var pager: InstaPageViewController!
    var allowTableViewScroll = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
//        scrollView.bounces = false
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func updateBottomConstraint(for tableView: UITableView) {
        containerConstraint.constant = tableView.contentSize.height
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.scrollView.flashScrollIndicators()
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
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        if let dir = direction, !didScroll{
            let vc = pager.pages[pager.currentIndex]
            self.pager.setViewControllers([vc], direction: dir, animated: true, completion: { (completion) in
                if let vc = vc as? InstaContentViewController{
                    self.updateBottomConstraint(for: vc.tableView)
                }
            })
        }else if let _ = direction, didScroll{
            let vc = pager.pages[pager.currentIndex]
            if let vc = vc as? InstaContentViewController{
                self.updateBottomConstraint(for: vc.tableView)
            }
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

