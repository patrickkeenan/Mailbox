//
//  InboxViewController.swift
//  Mailbox
//
//  Created by Patrick Keenan on 5/30/16.
//  Copyright © 2016 Patrick Keenan. All rights reserved.
//

import UIKit

class InboxViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var list: UIImageView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var leftAction: UIImageView!
    @IBOutlet weak var deleteAction: UIImageView!
    @IBOutlet weak var rightAction: UIImageView!
    @IBOutlet weak var listAction: UIImageView!
    @IBOutlet weak var modalList: UIImageView!
    @IBOutlet weak var modalSnooze: UIImageView!
    @IBOutlet weak var modalButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    
    var initalPanX: CGFloat!
    var red: UIColor!
    var green: UIColor!
    var yellow: UIColor!
    var brown: UIColor!
    var gray: UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    scrollView.frame.size.height = view.frame.size.height - 65
    scrollView.contentSize.height = list.frame.size.height + list.frame.origin.y
        let panGestureRecognizer = UIPanGestureRecognizer(target:  self, action: #selector(InboxViewController.onCustomPan(_:)))

        messageView.addGestureRecognizer(panGestureRecognizer)
        
        red = UIColor.init(red: 231/255, green: 61/255, blue: 15/255, alpha: 1)
        green = UIColor.init(red: 85/255, green: 213/255, blue: 80/255, alpha: 1)
        yellow = UIColor.init(red: 254/255, green: 204/255, blue: 27/255, alpha: 1)
        brown = UIColor.init(red: 206/255, green: 149/255, blue: 98/255, alpha: 1)
        gray = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        
        modalButton.enabled = false
        
        let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(InboxViewController.onEdgePan(_:)))
        edgeGesture.edges = UIRectEdge.Left
        contentView.addGestureRecognizer(edgeGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func onEdgePan(panGestureRecognizer: UIPanGestureRecognizer) {
        print("edge pan")
        let point = panGestureRecognizer.locationInView(view)
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            print("Gesture began at: \(point)")
            initalPanX = point.x
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            print("Gesture changed at: \(point)")
            let currentX = point.x - initalPanX
            contentView.frame.origin.x = currentX
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            print("Gesture ended at: \(point)")
            if contentView.frame.origin.x > 60 {
                UIView.animateWithDuration(0.3, animations: {
                    self.contentView.frame.origin.x = 300
                })
            }else{
                UIView.animateWithDuration(0.3, animations: {
                    self.contentView.frame.origin.x = 0
                })
            }
        }
    }
    func onCustomPan(panGestureRecognizer: UIPanGestureRecognizer) {
        
        // Absolute (x,y) coordinates in parent view
        let point = panGestureRecognizer.locationInView(view)
        
        // Relative change in (x,y) coordinates from where gesture began.
        // let translation = panGestureRecognizer.translationInView(view)
        // let velocity = panGestureRecognizer.velocityInView(view)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            print("Gesture began at: \(point)")
            initalPanX = point.x
            rightAction.alpha = 1
            leftAction.alpha = 1
            listAction.alpha = 0
            deleteAction.alpha = 0
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            
            
            let currentX = point.x - initalPanX - 320
            print("Gesture changed at: \(currentX)")
            messageView.frame.origin.x = currentX
            if currentX > 260 - 320{
                messageView.backgroundColor = red
                leftAction.alpha = 0
                deleteAction.alpha = 1
            }else if currentX > 60 - 320{
                messageView.backgroundColor = green
                leftAction.alpha = 1
                deleteAction.alpha = 0
            }else if currentX < -260 - 320{
                messageView.backgroundColor = brown
                listAction.alpha = 1
                rightAction.alpha = 0
            }else if currentX < -60 - 320{
                messageView.backgroundColor = yellow
                listAction.alpha = 0
                rightAction.alpha = 1
            }else{
                messageView.backgroundColor = gray
            }
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            print("Gesture ended at: \(point)")
                
            let currentX = point.x - initalPanX - 320
            var newX: CGFloat! = 0
            messageView.frame.origin.x = currentX
            if currentX > 260 - 320{
                print("Action: Delete")
                newX = 0
            }else if currentX > 60 - 320{
                print("Action: Done")
                newX = 0
            }else if currentX < -260 - 320{
                print("Action: List")
                newX = -640
                UIView.animateWithDuration(0.3, animations: {
                    self.modalList.alpha = 1
                })
                modalButton.enabled = true
            }else if currentX < -60 - 320{
                print("Action: Schedule")
                newX = -640
                UIView.animateWithDuration(0.3, animations: {
                    self.modalSnooze.alpha = 1
                })
                modalButton.enabled = true
            }else{
                newX = -320
            }
            
            UIView.animateWithDuration(0.3, animations: {
                self.messageView.frame.origin.x = newX
            }, completion: {(finished:Bool) in
                // the code you put here will be compiled once the animation finishes
                if(newX != -320){
                    UIView.animateWithDuration(0.3, animations: {
                        self.messageView.frame.size.height = 0
                        self.list.frame.origin.y = self.messageView.frame.origin.y
                    })
                }
            })
        }
    }

    @IBAction func modalTap(sender: AnyObject) {
        UIView.animateWithDuration(0.3, animations: {
            self.modalList.alpha = 0
            self.modalSnooze.alpha = 0
            self.messageView.frame.origin.x = -320
            self.messageView.frame.size.height = 86
            self.list.frame.origin.y = self.messageView.frame.origin.y + 86
        })
        modalButton.enabled = false
    }
    
    @IBAction func hamButton(sender: AnyObject) {
        UIView.animateWithDuration(0.3, animations: {
            self.contentView.frame.origin.x = 300
            self.messageView.frame.size.height = 86
            self.messageView.frame.origin.x = -320
            self.list.frame.origin.y = self.messageView.frame.origin.y + 86
        })
    }
    @IBAction func menuTap(sender: AnyObject) {
        UIView.animateWithDuration(0.3, animations: {
            self.contentView.frame.origin.x = 0
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
