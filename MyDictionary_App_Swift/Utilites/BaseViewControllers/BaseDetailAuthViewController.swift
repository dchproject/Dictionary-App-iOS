//
//  BaseDetailAuthViewController.swift
//  MyDictionary_App_Swift
//
//  Created by Dmytro Chumakov on 13.09.2021.
//

import UIKit

open class BaseDetailAuthViewController: BaseAuthViewController {
    
    internal let backButtonSize: CGSize = .init(width: 40, height: 40)
    internal let backButton: UIButton = {
        let button: UIButton = .init()
        button.setImage(MDAppStyling.Image.back_white_arrow.image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    internal let titleLabel: UILabel = {
        let label: UILabel = .init()
        label.font = MDAppStyling.Font.MyriadProSemiBold.font(ofSize: 34)
        label.textColor = MDAppStyling.Color.md_White_0_Light_Appearence.color()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(title: String) {
        titleLabel.text = title
        super.init()
    }
    
    deinit {
        debugPrint(#function, Self.self)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func loadView() {
        super.loadView()
        addViews()
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addConstraints()
    }
    
}

// MARK: - Add Views
fileprivate extension BaseDetailAuthViewController {
    
    func addViews() {
        addTitleLabel()
        addBackButton()
    }
    
    func addTitleLabel() {
        view.addSubview(titleLabel)
    }
    
    func addBackButton() {
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        view.addSubview(backButton)
    }
    
}

// MARK: - Add Constraints
fileprivate extension BaseDetailAuthViewController {
    
    func addConstraints() {
        addTitleLabelConstraints()
        addBackButtonConstraints()
    }
    
    func addTitleLabelConstraints() {
        
        NSLayoutConstraint.addEqualLeftConstraintAndActivate(item: self.titleLabel,
                                                             toItem: self.navigationBarView,
                                                             constant: 16)
        
        NSLayoutConstraint.addEqualRightConstraintAndActivate(item: self.titleLabel,
                                                              toItem: self.navigationBarView,
                                                              constant: -16)
        
        NSLayoutConstraint.addEqualBottomConstraintAndActivate(item: self.titleLabel,
                                                               toItem: self.navigationBarView,
                                                               constant: -16)
        
    }
    
    func addBackButtonConstraints() {
        
        NSLayoutConstraint.addEqualConstraintAndActivate(item: self.backButton,
                                                         attribute: .bottom,
                                                         toItem: self.titleLabel,
                                                         attribute: .top,
                                                         constant: -16)
        
        NSLayoutConstraint.addEqualLeftConstraintAndActivate(item: self.backButton,
                                                             toItem: self.navigationBarView,
                                                             constant: 18)
        
    }
    
}

// MARK: - Actions
fileprivate extension BaseDetailAuthViewController {
    
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
}
