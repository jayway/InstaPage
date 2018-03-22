//
//  InstaPageViewController.swift
//  InstaPage
//
//  Created by Felix Hedlund on 2018-03-21.
//  Copyright © 2018 Jayway AB. All rights reserved.
//

import UIKit

protocol InstaPageDelegate{
    func changeToIndex(index: Int)
}

class InstaPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var currentIndex = 0
    var instaDelegate: InstaPageDelegate!
    var tableViewDelegate: TableViewDelegate!
    
    public lazy var pages: [UIViewController] = {
        return [
            self.getViewController(color: #colorLiteral(red: 0.9749749303, green: 1, blue: 0.437482059, alpha: 1)),
            self.getViewController(color: #colorLiteral(red: 0.7227508426, green: 1, blue: 0.9128507376, alpha: 1)),
            self.getViewController(color: #colorLiteral(red: 1, green: 0.7548497319, blue: 1, alpha: 1))
        ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        if let firstVC = pages.first
        {
            self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }
    
    fileprivate func getViewController(color: UIColor) -> UIViewController
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "content") as! InstaContentViewController
        vc.view.backgroundColor = color
        vc.tableViewDelegate = tableViewDelegate
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0          else { return nil }
        
        guard pages.count > previousIndex else { return nil        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else { return nil }
        
        guard pages.count > nextIndex else { return nil         }
        
        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewControllerIndex = pages.index(of: pageViewController.viewControllers!.first!) else { return }
        for controller in previousViewControllers{
            if let vc = controller as? InstaContentViewController{
                vc.tableView.scrollRectToVisible(CGRect(x: 1, y: 1, width: 1, height: 1), animated: false)
            }
        }
        instaDelegate.changeToIndex(index: viewControllerIndex)
//        self.changeViewControllers(sender: tabButtons[viewControllerIndex], didScroll: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
