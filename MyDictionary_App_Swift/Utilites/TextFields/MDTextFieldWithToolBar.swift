//
//  MDTextFieldWithToolBar.swift
//  MyDictionary_App_Swift
//
//  Created by Dmytro Chumakov on 15.08.2021.
//

import UIKit

open class MDTextFieldWithToolBar: UITextField {
    
    fileprivate let keyboardToolbar: MDKeyboardToolbar
    fileprivate let rectInset: UIEdgeInsets
    
    init(frame: CGRect = .zero,
         rectInset: UIEdgeInsets,
         keyboardToolbar: MDKeyboardToolbar) {
        
        self.keyboardToolbar = keyboardToolbar
        self.rectInset = rectInset
        
        super.init(frame: frame)
        configureUI()
        
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: rectInset)
    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: rectInset)
    }
    
}

// MARK: - Configure UI
fileprivate extension MDTextFieldWithToolBar {
    
    func configureUI() {
        keyboardToolbar.configureWithDoneButton(textField: self,
                                                target: self,
                                                action: #selector(toolBarDoneButtonAction))
    }
    
}

// MARK: - Actions
fileprivate extension MDTextFieldWithToolBar {
    
    @objc func toolBarDoneButtonAction() {
        self.resignFirstResponder()
    }
    
}
