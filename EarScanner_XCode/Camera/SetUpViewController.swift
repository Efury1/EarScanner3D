//
//  SetUpViewController.swift
//  EarScanner_XCode
//
//  Created by Eliza Fury on 12/9/21.
//

import UIKit
import EasyPeasy

class SetUpViewController: UIViewController {
    
    var currentProgress = 0
    
    let containerView = UIView()
    
    var view1: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.alpha = 0.5
        return view
    }()
    let view2: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.alpha = 0.5
        return view
    }()
    let view3: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.alpha = 0.5
        return view
    }()
    let view4: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.alpha = 0.5
        return view
    }()
    
    let line1: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.alpha = 0.5
        return view
    }()
    let line2: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.alpha = 0.5
        return view
    }()
    let line3: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.alpha = 0.5
        return view
    }()
    
    let lineHeight: CGFloat = 5
    
    var containerWidth: CGFloat {
        self.view.frame.size.width * 0.95
    }
    var containerHeight: CGFloat {
        self.containerWidth/7
    }
    var viewSize: CGFloat {
        self.containerWidth/9
    }
    var lineWidth: CGFloat {
        self.containerWidth/8
    }
    var padding: CGFloat {
        self.containerWidth/45
    }
    
    lazy var nextButton: UIButton = {
       let button = UIButton()
        button.setTitle("Next", for: .normal)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapNextButton))
        button.addGestureRecognizer(tapGesture)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    override func loadView() {
        super.loadView()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(containerView)
        
        containerView.easy.layout(Top(padding).to(view.safeAreaLayoutGuide, .top), CenterX(), Width(containerWidth), Height(containerHeight))
        
        addViews(views: [view1, view2, view3, view4])
        addViews(views: [line1, line2, line3])
        
        view1.easy.layout(CenterY(), Left(padding).to(containerView, .left), Size(viewSize))
        view1.rounded(radius: viewSize/2)
        
        line1.easy.layout(CenterY(), Left(padding).to(view1, .right), Height(lineHeight), Width(lineWidth))

        line1.rounded(radius: lineHeight/2)
        
        view2.easy.layout(CenterY(), Left(padding).to(line1, .right), Size(viewSize))
        view2.rounded(radius: viewSize/2)
        
        line2.easy.layout(CenterY(), Left(padding).to(view2, .right), Height(lineHeight), Width(lineWidth))
        line2.rounded(radius: lineHeight/2)
        
        view3.easy.layout(CenterY(), Left(padding).to(line2, .right), Size(viewSize))
        view3.rounded(radius: viewSize/2)
        
        line3.easy.layout(CenterY(), Left(padding).to(view3, .right), Height(lineHeight), Width(lineWidth))
        line3.rounded(radius: lineHeight/2)
        
        view4.easy.layout(CenterY(), Left(padding).to(line3, .right), Size(viewSize))
        view4.rounded(radius: viewSize/2)
        
        
        view.addSubview(nextButton)
        nextButton.easy.layout(CenterX(), CenterY(), Width(200), Height(50))
        nextButton.backgroundColor = .red
    }
    
    private func addViews(views: [UIView]) {
        for view in views {
            containerView.addSubview(view)
        }
    }
    
}

// MARK: - Action Responder
extension SetUpViewController {
    @objc private func onTapNextButton() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else {
                return
            }
            switch self.currentProgress {
            case 0:
                self.view1.alpha = 1
            case 1:
                self.view2.alpha = 1
                self.line1.alpha = 1
            case 2:
                self.view3.alpha = 1
                self.line2.alpha = 1
            case 3:
                self.view4.alpha = 1
                self.line3.alpha = 1
            default:
                self.view1.alpha = 0.5
                self.view2.alpha = 0.5
                self.line1.alpha = 0.5
                self.view3.alpha = 0.5
                self.line2.alpha = 0.5
                self.view4.alpha = 0.5
                self.line3.alpha = 0.5
            }
            if self.currentProgress > 3 {                
                self.currentProgress = 0
            } else {
                self.currentProgress += 1
            }
        }
    }
}
