//
//  WordListDataManager.swift
//  MyDictionary_App_Swift
//
//  Created by Dmytro Chumakov on 16.05.2021.
//

import Foundation

protocol WordListDataManagerInputProtocol {
    var dataProvider: WordListDataProviderProcotol { get }
    func readAndAddWordsToDataProvider()
    func filterWords(_ searchText: String?)
    func clearWordFilter()
    func deleteWord(atIndexPath indexPath: IndexPath)
    func addWord(_ newValue: CDWordEntity) -> IndexPath
    func deleteWord(atWordResponse word: CDWordEntity) -> IndexPath
    func updateWord(atWordResponse word: CDWordEntity) -> IndexPath
}

protocol WordListDataManagerOutputProtocol: AnyObject {
    func readAndAddWordsToDataProviderResult(_ result: MDOperationResultWithoutCompletion<Void>)
    func filteredWordsResult(_ result: MDOperationResultWithoutCompletion<Void>)
    func clearWordFilterResult(_ result: MDOperationResultWithoutCompletion<Void>)
}

protocol WordListDataManagerProtocol: WordListDataManagerInputProtocol {
    var dataManagerOutput: WordListDataManagerOutputProtocol? { get set }
}

final class WordListDataManager: WordListDataManagerProtocol {
    
    fileprivate let coreDataStorage: MDWordCoreDataStorageProtocol
    fileprivate let filterSearchTextService: MDFilterSearchTextServiceProtocol
    
    var dataProvider: WordListDataProviderProcotol
    internal weak var dataManagerOutput: WordListDataManagerOutputProtocol?
    
    init(dataProvider: WordListDataProviderProcotol,
         coreDataStorage: MDWordCoreDataStorageProtocol,
         filterSearchTextService: MDFilterSearchTextServiceProtocol) {
        
        self.dataProvider = dataProvider
        self.coreDataStorage = coreDataStorage
        self.filterSearchTextService = filterSearchTextService
        
    }
    
    deinit {
        debugPrint(#function, Self.self)
    }
    
}

// MARK: - WordListDataManagerInputProtocol
extension WordListDataManager: WordListDataManagerInputProtocol {
    
    func readAndAddWordsToDataProvider() {
        
        coreDataStorage.readAllWords(byCourseUUID: dataProvider.course.course.uuid!) { [unowned self] result in
            
            switch result {
                
            case .success(let readWords):
                
                //
                let sortedWords = sortWords(readWords)
                //
                
                DispatchQueue.main.async {
                    
                    // Set Words
                    self.dataProvider.filteredWords = sortedWords
                    // Pass Result
                    self.dataManagerOutput?.readAndAddWordsToDataProviderResult(.success(()))
                    //
                    
                }
                
                //
                break
                //
                
            case .failure(let error):
                
                DispatchQueue.main.async {
                    
                    // Pass Result
                    self.dataManagerOutput?.readAndAddWordsToDataProviderResult(.failure(error))
                    //
                    
                }
                
                //
                break
                //
                
            }
            
        }
        
    }
    
    func filterWords(_ searchText: String?) {
        
        coreDataStorage.readAllWords(byCourseUUID: dataProvider.course.course.uuid!) { [unowned self] readResult in
            
            switch readResult {
                
            case .success(let readWords):
                
                //
                let sortedWords = sortWords(readWords)
                //
                
                //
                filterSearchTextService.filter(input: sortedWords,
                                               searchText: searchText) { [unowned self] (filteredResult) in
                    
                    DispatchQueue.main.async {
                        
                        // Set Filtered Result
                        self.dataProvider.filteredWords = filteredResult as! [CDWordEntity]
                        
                        // Pass Result
                        self.dataManagerOutput?.filteredWordsResult(.success(()))
                        //
                        
                    }
                    
                }
                
                //
                break
                //
                
            case .failure(let error):
                
                DispatchQueue.main.async {
                    
                    // Pass Result
                    self.dataManagerOutput?.filteredWordsResult(.failure(error))
                    //
                    
                }
                
                //
                break
                //
                
            }
            
        }
        
    }
    
    func clearWordFilter() {
        
        coreDataStorage.readAllWords(byCourseUUID: dataProvider.course.course.uuid!) { [unowned self] readResult in
            
            switch readResult {
                
            case .success(let readWords):
                
                //
                let sortedWords = sortWords(readWords)
                //
                
                DispatchQueue.main.async {
                    
                    // Set Read Results
                    self.dataProvider.filteredWords = sortedWords
                    // Pass Result
                    self.dataManagerOutput?.clearWordFilterResult(.success(()))
                    //
                    
                }
                
                //
                break
                //
                
            case .failure(let error):
                
                DispatchQueue.main.async {
                    
                    // Pass Result
                    self.dataManagerOutput?.clearWordFilterResult(.failure(error))
                    //
                    
                }
                
                //
                break
                //
                
            }
            
        }
        
    }
    
    func deleteWord(atIndexPath indexPath: IndexPath) {
        dataProvider.deleteWord(atIndexPath: indexPath)
    }
    
    func addWord(_ newValue: CDWordEntity) -> IndexPath {
        //
        self.dataProvider.filteredWords.insert(newValue, at: .zero)
        //
        return .init(row: .zero, section: section)
    }
    
    func deleteWord(atWordResponse word: CDWordEntity) -> IndexPath {
        //
        let row = dataProvider.filteredWords.firstIndex(where: { $0.uuid == word.uuid })!
        let indexPath: IndexPath = .init(row: row,
                                         section: section)
        // Delete Word
        deleteWord(atIndexPath: indexPath)
        //
        return indexPath
    }
    
    func updateWord(atWordResponse word: CDWordEntity) -> IndexPath {
        //
        let row = dataProvider.filteredWords.firstIndex(where: { $0.uuid == word.uuid })!
        let indexPath: IndexPath = .init(row: row,
                                         section: section)
        // Update Word
        dataProvider.updateWord(atIndexPath: indexPath,
                                updatedWord: word)
        //
        return indexPath
    }
    
}

// MARK: - Private Methods
fileprivate extension WordListDataManager {
    
    var section: Int {
        return .zero
    }
    
    func sortWords(_ input: [CDWordEntity]) -> [CDWordEntity] {
        return input.sorted(by: { $0.createdAt! > $1.createdAt! })
    }
    
}
