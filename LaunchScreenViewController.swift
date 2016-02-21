//
//  LaunchScreenViewController.swift
//  Fame
//
//  Created by Matthew Wall on 2/4/16.
//  Copyright © 2016 Matthew Wall. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    
    var animator:UIDynamicAnimator!
//    var container:UICollisionBehavior!
    var snap:UISnapBehavior!
    var dynamicItem:UIDynamicItemBehavior!
    var gravity:UIGravityBehavior!
    
    var panGestureRecognizer: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setup(){
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        panGestureRecognizer.cancelsTouchesInView = false
        
        self.view.addGestureRecognizer(panGestureRecognizer)
        
        animator = UIDynamicAnimator(referenceView: self.view.superview!)
        dynamicItem = UIDynamicItemBehavior(items: [self.view])
        dynamicItem.allowsRotation = false
        dynamicItem.elasticity = 0
        
        gravity = UIGravityBehavior(items: [self.view])
        gravity.gravityDirection = CGVectorMake(0,-1)
        
//        container = UICollisionBehavior(items: [self.view])
        
        animator.addBehavior(gravity)
        animator.addBehavior(dynamicItem)
        
//        animator.addBehavior(container)
        
    }

//    func configureContainer(){
//        let boundaryWidth = UIScreen.mainScreen().bounds.size.width
//        container.addBoundaryWithIdentifier("upper", fromPoint: CGPointMake(0, self.view.frame.size.height), toPoint: CGPointMake(boundaryWidth, -self.view.frame.size.height))
//        
//        let boundaryHeight = UIScreen.mainScreen().bounds.size.height
//        container.addBoundaryWithIdentifier("lower", fromPoint: CGPointMake(0, boundaryHeight), toPoint: CGPointMake(boundaryWidth, -boundaryHeight))
//    }
    
    
    @IBAction func handlePan(pan: UIPanGestureRecognizer) {
        let velocity = pan.velocityInView(self.view.superview).y
        
        var movement = self.view.frame
        
        movement.origin.x = 0
        movement.origin.y = movement.origin.y + (velocity * 0.05)
        
        if pan.state == .Ended {
            panGestureEnded()
        }
        else if pan.state == .Began {
//            if pan.locationInView(self.view.superview).y > (self.view.superview?.bounds.size.height)! / 1.2 {
//                return
//            }
            snapToTop()
        }
        else {
            animator.removeBehavior(snap)
            snap = UISnapBehavior(item: self.view, snapToPoint: CGPointMake(CGRectGetMidX(movement), CGRectGetMidY(movement)))
            animator.addBehavior(snap)
        }
    }
    
    func panGestureEnded(){
        animator.removeBehavior(snap)
        let velocity = dynamicItem.linearVelocityForItem(self.view)
        
        if fabs(Float(velocity.y)) > 250 {
            if velocity.y < 0 {
                snapToBottom()
            }
            else {
                snapToTop()
            }
        }
        else {
            if let superViewHeight = self.view.superview?.bounds.size.height {
                if self.view.frame.origin.y > superViewHeight / 2 {
                    snapToTop()
                }
                else {
                    snapToBottom()
                }
            }
        }
    }
    
    func snapToBottom(){
        gravity.gravityDirection = CGVectorMake(0, 2.5)
    }
    
    func snapToTop(){
        gravity.gravityDirection = CGVectorMake(0,-2.5)
    }
}
