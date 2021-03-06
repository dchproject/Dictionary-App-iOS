//
//  WordListInteractor.swift
//  MyDictionary_App_Swift
//
//  Created by Dmytro Chumakov on 16.05.2021.
//

import Foundation

protocol WordListInteractorInputProtocol: MDViewDidLoadProtocol {
    var tableViewDelegate: WordListTableViewDelegateProtocol { get }
    var tableViewDataSource: WordListTableViewDataSourceProtocol { get }
    var searchBarDelegate: MDSearchBarDelegateImplementationProtocol { get }
    func addNewWordButtonClicked()
}

protocol WordListInteractorOutputProtocol: AnyObject,
                                           MDHideKeyboardProtocol,
                                           MDReloadDataProtocol,
                                           MDShowErrorProtocol,
                                           MDShowHideProgressHUD,
                                           MDDeleteRowProtocol,
                                           MDInsertRowProtocol,
                                           MDUpdateRowProtocol  {
    
    func showAddWord(withCourse course: CourseResponse)
    func showEditWord(withWord word: WordResponse)
    
}

protocol WordListInteractorProtocol: WordListInteractorInputProtocol,
                                     WordListDataManagerOutputProtocol {
    var interactorOutput: WordListInteractorOutputProtocol? { get set }
}

final class WordListInteractor: NSObject,
                                WordListInteractorProtocol {
    
    fileprivate let dataManager: WordListDataManagerInputProtocol
    fileprivate let wordManager: MDWordManagerProtocol
    fileprivate var bridge: MDBridgeProtocol
    
    internal var tableViewDelegate: WordListTableViewDelegateProtocol
    internal var tableViewDataSource: WordListTableViewDataSourceProtocol
    internal var searchBarDelegate: MDSearchBarDelegateImplementationProtocol
    
    internal weak var interactorOutput: WordListInteractorOutputProtocol?
    
    init(dataManager: WordListDataManagerInputProtocol,
         tableViewDelegate: WordListTableViewDelegateProtocol,
         tableViewDataSource: WordListTableViewDataSourceProtocol,
         searchBarDelegate: MDSearchBarDelegateImplementationProtocol,
         wordManager: MDWordManagerProtocol,
         bridge: MDBridgeProtocol) {
        
        self.dataManager = dataManager
        self.tableViewDelegate = tableViewDelegate
        self.tableViewDataSource = tableViewDataSource
        self.searchBarDelegate = searchBarDelegate
        self.wordManager = wordManager
        self.bridge = bridge
        
        super.init()
        subscribe()
        
    }
    
    deinit {
        debugPrint(#function, Self.self)
    }
    
}

// MARK: - WordListDataManagerOutputProtocol
extension WordListInteractor {
    
    func readAndAddWordsToDataProviderResult(_ result: MDOperationResultWithoutCompletion<Void>) {
        checkResultAndExecuteReloadDataOrShowError(result)
    }
    
    func filteredWordsResult(_ result: MDOperationResultWithoutCompletion<Void>) {
        checkResultAndExecuteReloadDataOrShowError(result)
    }
    
    func clearWordFilterResult(_ result: MDOperationResultWithoutCompletion<Void>) {
        checkResultAndExecuteReloadDataOrShowError(result)
    }
    
}

// MARK: - WordListInteractorInputProtocol
extension WordListInteractor {
    
    func viewDidLoad() {
        dataManager.readAndAddWordsToDataProvider()
    }
    
    func addNewWordButtonClicked() {
        interactorOutput?.showAddWord(withCourse: dataManager.dataProvider.course)
    }
    
}

// MARK: - Subscribe
fileprivate extension WordListInteractor {
    
    func subscribe() {
        //
        searchBarCancelButtonAction_Subscribe()
        //
        searchBarSearchButtonAction_Subscribe()
        //
        searchBarTextDidChangeAction_Subscribe()
        //
        searchBarShouldClearAction_Subscribe()
        //
        tableViewDataSourceDeleteButtonAction_Subscribe()
        //
        bridge_DidAddWord_Subscribe()
        //
        bridge_DidDeleteWord_Subscribe()
        //
        bridge_DidUpdateWord_Subscribe()
        //
        tableViewDelegate_DidSelectWord_Subscribe()
        //
    }
    
    func searchBarCancelButtonAction_Subscribe() {
        
        searchBarDelegate.searchBarCancelButtonAction = { [weak self] in
            self?.interactorOutput?.hideKeyboard()
        }
        
    }
    
    func searchBarSearchButtonAction_Subscribe() {
        
        searchBarDelegate.searchBarSearchButtonAction = { [weak self] in
            self?.interactorOutput?.hideKeyboard()
        }
        
    }
    
    func searchBarTextDidChangeAction_Subscribe() {
        
        searchBarDelegate.searchBarTextDidChangeAction = { [weak self] (searchText) in
            self?.dataManager.filterWords(searchText)
        }
        
    }
    
    func searchBarShouldClearAction_Subscribe() {
        
        searchBarDelegate.searchBarShouldClearAction = { [weak self] in
            self?.dataManager.clearWordFilter()
        }
        
    }
    
    func tableViewDataSourceDeleteButtonAction_Subscribe() {
        
        tableViewDataSource.deleteButtonAction = { [unowned self] (indexPath) in
            
            // Show Progress HUD
            interactorOutput?.showProgressHUD()
            //
            let word = dataManager.dataProvider.wordListCellModel(atIndexPath: indexPath)!.wordResponse
            // Delete Word From API And Storage
            wordManager.deleteWordFromApiAndAllStorage(byUserId: word.userId,
                                                       byCourseId: word.courseId,
                                                       byWordId: word.wordId) { [unowned self] deleteWordResult in
                
                switch deleteWordResult {
                    
                case .success:
                    
                    DispatchQueue.main.async {
                        
                        // Hide Progress HUD
                        self.interactorOutput?.hideProgressHUD()
                        //
                        self.dataManager.deleteWord(atIndexPath: indexPath)
                        //
                        self.interactorOutput?.deleteRow(atIndexPath: indexPath)
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
        
    }
    
    func bridge_DidAddWord_Subscribe() {
        
        bridge.didAddWord = { [unowned self] (word) in
            //
            interactorOutput?.insertRow(atIndexPath: dataManager.addWord(word))
            //
        }
        
    }
    
    func bridge_DidDeleteWord_Subscribe() {
        
        bridge.didDeleteWord = { [unowned self] (deleteWord) in
            //
            interactorOutput?.deleteRow(atIndexPath: dataManager.deleteWord(atWordResponse: deleteWord))
            //
        }
        
    }
    
    func bridge_DidUpdateWord_Subscribe() {
        
        bridge.didUpdateWord = { [unowned self] (updatedWord) in
            //
            interactorOutput?.updateRow(atIndexPath: dataManager.updateWord(atWordResponse: updatedWord))
            //
        }
        
    }
    
    func tableViewDelegate_DidSelectWord_Subscribe() {
        
        tableViewDelegate.didSelectWord = { [weak self] (word) in
            //
            self?.interactorOutput?.showEditWord(withWord: word)
            //
        }
        
    }
    
}

// MARK: - Private Methods
fileprivate extension WordListInteractor {
    
    func checkResultAndExecuteReloadDataOrShowError(_ result: MDOperationResultWithoutCompletion<Void>) {
        
        switch result {
            
        case .success:
            
            //
            interactorOutput?.reloadData()
            //
            break
            //
            
        case .failure(let error):
            
            //
            interactorOutput?.showError(error)
            //
            break
            //
            
        }
        
    }
    
}
