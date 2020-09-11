//
//  AnimationTransition.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/09/11.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import UIKit
import SnapKit

class AnimationTransition: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {
    
    private var originFrame: CGRect?
    
    func setFrame(frame: CGRect?) {
        self.originFrame = frame
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let toView = transitionContext.view(forKey: .to) else { return }
        guard let originFrame = originFrame else { return }
        
        toView.frame = originFrame
        toView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        containerView.addSubview(toView)
        
        let animation = { toView.transform = .identity }
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseOut,
                       animations: animation) { completed in
            toView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            UIView.animate(withDuration: 0.6) {
                containerView.layoutIfNeeded()
            }
            transitionContext.completeTransition(completed)
        }
    }
}

class DisMissAnimationTransition: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        
        let animation = { fromView.alpha = 0 }
        UIView.animate(withDuration: 0.2,
                       animations: animation) { completed in
            transitionContext.completeTransition(completed)
        }
    }
}
