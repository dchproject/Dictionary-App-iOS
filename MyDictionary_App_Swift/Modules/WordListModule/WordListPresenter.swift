//
//  WordListPresenter.swift
//  MyDictionary_App_Swift
//
//  Created by Dmytro Chumakov on 16.05.2021.
//

import Foundation

protocol WordListPresenterInputProtocol: CollectionViewDelegateFlowLayoutPropertyProtocol,
                                         CollectionViewDataSourcePropertyProtocol {
    
}

protocol WordListPresenterOutputProtocol: AnyObject,
                                          ReloadDataProtocol,
                                          AppearanceHasBeenUpdatedProtocol {
    
}

protocol WordListPresenterProtocol: WordListPresenterInputProtocol,
                                    WordListInteractorOutputProtocol {
    var presenterOutput: WordListPresenterOutputProtocol? { get set }
}

final class WordListPresenter: NSObject,
                               WordListPresenterProtocol {
    
    fileprivate let interactor: WordListInteractorInputProtocol
    fileprivate let router: WordListRouterProtocol
    
    internal weak var presenterOutput: WordListPresenterOutputProtocol?
    internal var collectionViewDelegate: CollectionViewDelegateFlowLayout {
        return self.interactor.collectionViewDelegate
    }
    internal var collectionViewDataSource: CollectionViewDataSource {
        return self.interactor.collectionViewDataSource
    }
    
    init(interactor: WordListInteractorInputProtocol,
         router: WordListRouterProtocol) {
        self.interactor = interactor
        self.router = router
        super.init()
        subscribe()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        debugPrint(#function, Self.self)
    }
    
}

// MARK: - WordListInteractorOutputProtocol
extension WordListPresenter {
    
    func appearanceHasBeenUpdated(_ newValue: AppearanceType) {
        self.presenterOutput?.appearanceHasBeenUpdated(newValue)
    }
    
}

// MARK: - Subscribe
fileprivate extension WordListPresenter {
    
    func subscribe() {
        
    }
    
}

// MARK: - Actions
fileprivate extension WordListPresenter {       
    
}
