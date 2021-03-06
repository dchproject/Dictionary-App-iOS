//
//  AddWordInteractor.swift
//  MyDictionary_App_Swift
//
//  Created Dmytro Chumakov on 27.09.2021.

import UIKit

protocol AddWordInteractorInputProtocol {
    var textFieldDelegate: MDWordTextFieldDelegateImplementationProtocol { get }
    var textViewDelegate: MDWordTextViewDelegateImplementationProtocol { get }
    func addButtonClicked()
    func wordTextFieldDidChange(_ text: String?)
}

protocol AddWordInteractorOutputProtocol: AnyObject,
                                          MDShowErrorProtocol,
                                          MDShowHideProgressHUD,
                                          MDCloseModuleProtocol {
    
    func makeWordDescriptionTextViewActive()
    
    func updateWordTextFieldCounter(_ count: Int)
    func updateWordTextViewCounter(_ count: Int)
    func wordTextFieldShouldClearAction()        
    
}

protocol AddWordInteractorProtocol: AddWordInteractorInputProtocol,
                                    AddWordDataManagerOutputProtocol {
    var interactorOutput: AddWordInteractorOutputProtocol? { get set }
}

final class AddWordInteractor: NSObject,
                               AddWordInteractorProtocol {
    
    fileprivate let dataManager: AddWordDataManagerInputProtocol
    fileprivate let wordManager: MDWordManagerProtocol
    fileprivate let bridge: MDBridgeProtocol
    
    var textFieldDelegate: MDWordTextFieldDelegateImplementationProtocol
    var textViewDelegate: MDWordTextViewDelegateImplementationProtocol
    
    internal weak var interactorOutput: AddWordInteractorOutputProtocol?
    
    init(dataManager: AddWordDataManagerInputProtocol,
         textFieldDelegate: MDWordTextFieldDelegateImplementationProtocol,
         textViewDelegate: MDWordTextViewDelegateImplementationProtocol,
         wordManager: MDWordManagerProtocol,
         bridge: MDBridgeProtocol) {
        
        self.dataManager = dataManager
        self.textFieldDelegate = textFieldDelegate
        self.textViewDelegate = textViewDelegate
        self.wordManager = wordManager
        self.bridge = bridge
        
        super.init()
        subscribe()
        
    }
    
    deinit {
        debugPrint(#function, Self.self)
    }
    
}

// MARK: - AddWordDataManagerOutputProtocol
extension AddWordInteractor: AddWordDataManagerOutputProtocol {
    
}

// MARK: - AddWordInteractorInputProtocol
extension AddWordInteractor: AddWordInteractorInputProtocol {
    
    func addButtonClicked() {
        
        if (MDConstants.Text.textIsEmpty(dataManager.getWordText)) {
            interactorOutput?.showError(MDAddWordError.wordTextIsEmpty)
            return
        }
        
        if (MDConstants.Text.textIsEmpty(dataManager.getWordDescription)) {
            interactorOutput?.showError(MDAddWordError.wordDescriptionIsEmpty)
            return
        }
        
        // Show Progress HUD
        interactorOutput?.showProgressHUD()
        //
        wordManager.addWord(courseId: dataManager.getCourse.courseId,
                            languageId: dataManager.getCourse.languageId,
                            wordText: dataManager.getWordText!,
                            wordDescription: dataManager.getWordDescription!,
                            languageName: dataManager.getCourse.languageName) { [unowned self] (result) in
            
            switch result {
                
            case .success(let wordResponse):
                
                DispatchQueue.main.async {
                    
                    // Hide Progress HUD
                    self.interactorOutput?.hideProgressHUD()
                    //
                    self.bridge.didAddWord?(wordResponse)
                    //
                    self.interactorOutput?.closeModule()
                    //
                    
                }
                
                //
                break
                //
                
            case .failure(let error):
                
                DispatchQueue.main.async {
                    
                    // Hide Progress HUD
                    self.interactorOutput?.hideProgressHUD()
                    //
                    self.interactorOutput?.showError(error)
                    //
                    
                }
                
                //
                break
                //
                
            }
            
        }
        
    }
    
    func wordTextFieldDidChange(_ text: String?) {
        dataManager.setWordText(text)
    }
    
}

// MARK: - Subscribe
fileprivate extension AddWordInteractor {
    
    func subscribe() {
        //
        wordTextField_ShouldReturnAction_Subscribe()
        //
        update_WordTextField_CounterAction_Subscribe()
        //
        wordTextField_ShouldClearAction_Subscribe()
        //
        wordDescriptionTextView_DidChangeAction_Subscribe()
        //
        update_WordDescriptionTextView_CounterAction_Subscribe()
        //
    }
    
    func wordTextField_ShouldReturnAction_Subscribe() {
        
        textFieldDelegate.wordTextFieldShouldReturnAction = { [weak self] in
            self?.interactorOutput?.makeWordDescriptionTextViewActive()
        }
        
    }
    
    func update_WordTextField_CounterAction_Subscribe() {
        
        textFieldDelegate.updateWordTextFieldCounterAction = { [weak self] (count) in
            self?.interactorOutput?.updateWordTextFieldCounter(count)
        }
        
    }
    
    func wordTextField_ShouldClearAction_Subscribe() {
        
        textFieldDelegate.wordTextFieldShouldClearAction = { [weak self] in
            self?.interactorOutput?.wordTextFieldShouldClearAction()
        }
        
    }
    
    func wordDescriptionTextView_DidChangeAction_Subscribe() {
        
        textViewDelegate.wordDescriptionTextViewDidChangeAction = { [weak self] (text) in
            //
            self?.dataManager.setWordDescription(text)
            //
        }
        
    }
    
    func update_WordDescriptionTextView_CounterAction_Subscribe() {
        
        textViewDelegate.updateWordDescriptionTextViewCounterAction = { [weak self] (count) in
            //
            self?.interactorOutput?.updateWordTextViewCounter(count)
            //
        }
        
    }
    
}
