//
//  MDAppDependencies.swift
//  MyDictionary_App_Swift
//
//  Created by Dmytro Chumakov on 07.07.2021.
//

import UIKit
import Firebase
import Reachability

protocol MDAppDependenciesProtocol {
    
    var rootWindow: UIWindow! { get set }
    var reachability: Reachability! { get }
    var coreDataStack: MDCoreDataStack! { get }
    
    // Manager
    var operationQueueManager: MDOperationQueueManagerProtocol! { get }
    //
    
    // API //
    var apiJWT: MDAPIJWTProtocol! { get }
    var apiUser: MDAPIUserProtocol! { get }
    var apiLanguage: MDAPILanguageProtocol! { get }
    var apiCourse: MDAPICourseProtocol! { get }
    var apiWord: MDAPIWordProtocol! { get }
    var apiAuth: MDAPIAuthProtocol! { get }
    var apiAccount: MDAPIAccountProtocol! { get }
    // End API //
    
    // Storage //
    var jwtStorage: MDJWTStorageProtocol! { get }
    var userStorage: MDUserStorageProtocol! { get }
    var languageStorage: MDLanguageStorageProtocol! { get }
    var courseStorage: MDCourseStorageProtocol! { get }
    var wordStorage: MDWordStorageProtocol! { get }
    // End Storage
    
    var appSettings: MDAppSettingsProtocol! { get }
    
    var fillMemoryService: MDFillMemoryServiceProtocol! { get }
    
    var bridge: MDBridgeProtocol! { get }
}

final class MDAppDependencies: NSObject,
                               MDAppDependenciesProtocol {
    
    var rootWindow: UIWindow!
    var reachability: Reachability!
    var coreDataStack: MDCoreDataStack!
    
    // Manager
    var operationQueueManager: MDOperationQueueManagerProtocol!
    //
    
    // API //
    var apiJWT: MDAPIJWTProtocol!
    var apiUser: MDAPIUserProtocol!
    var apiLanguage: MDAPILanguageProtocol!
    var apiCourse: MDAPICourseProtocol!
    var apiWord: MDAPIWordProtocol!
    var apiAuth: MDAPIAuthProtocol!
    var apiAccount: MDAPIAccountProtocol!
    // End API //
    
    // Storage //
    var jwtStorage: MDJWTStorageProtocol!
    var userStorage: MDUserStorageProtocol!
    var languageStorage: MDLanguageStorageProtocol!
    var courseStorage: MDCourseStorageProtocol!
    var wordStorage: MDWordStorageProtocol!
    // End Storage //
    
    var appSettings: MDAppSettingsProtocol!
    
    var fillMemoryService: MDFillMemoryServiceProtocol!
    
    var bridge: MDBridgeProtocol!
    
    override init() {
        super.init()
        configureDependencies()
    }
    
    deinit {
        debugPrint(#function, Self.self)
    }
    
}

extension MDAppDependencies {
    
    func configureDependencies() {
        
        guard let reachability = try? Reachability.init() else { fatalError("Impossible initialize Reachability Service") }
        self.reachability = reachability
        //
        let coreDataStack: MDCoreDataStack = .init()
        self.coreDataStack = coreDataStack
        //
        let requestDispatcher: MDRequestDispatcherProtocol = MDConstants.RequestDispatcher.defaultRequestDispatcher(reachability: reachability)
        //
        
        // Manager //
        //
        
        let operationQueues: [OperationQueue] = [createOperationQueue(byName: MDConstants.QueueName.jwtMemoryStorageOperationQueue),
                                                 createOperationQueue(byName: MDConstants.QueueName.jwtCoreDataStorageOperationQueue),
                                                 createOperationQueue(byName: MDConstants.QueueName.jwtAPIOperationQueue),
                                                 
                                                 createOperationQueue(byName: MDConstants.QueueName.userMemoryStorageOperationQueue),
                                                 createOperationQueue(byName: MDConstants.QueueName.userCoreDataStorageOperationQueue),
                                                 createOperationQueue(byName: MDConstants.QueueName.userAPIOperationQueue),
                                                 
                                                 createOperationQueue(byName: MDConstants.QueueName.languageMemoryStorageOperationQueue),
                                                 createOperationQueue(byName: MDConstants.QueueName.languageCoreDataStorageOperationQueue),
                                                 createOperationQueue(byName: MDConstants.QueueName.languageAPIOperationQueue),
                                                 
                                                 createOperationQueue(byName: MDConstants.QueueName.courseMemoryStorageOperationQueue),
                                                 createOperationQueue(byName: MDConstants.QueueName.courseCoreDataStorageOperationQueue),
                                                 createOperationQueue(byName: MDConstants.QueueName.courseAPIOperationQueue),
                                                 
                                                 createOperationQueue(byName: MDConstants.QueueName.wordMemoryStorageOperationQueue),
                                                 createOperationQueue(byName: MDConstants.QueueName.wordCoreDataStorageOperationQueue),
                                                 createOperationQueue(byName: MDConstants.QueueName.wordAPIOperationQueue),
                                                 
                                                 createOperationQueue(byName: MDConstants.QueueName.authAPIOperationQueue),
                                                 
                                                 createOperationQueue(byName: MDConstants.QueueName.accountAPIOperationQueue),
                                                 
        ]
        //
        let operationQueueManager: MDOperationQueueManagerProtocol = MDOperationQueueManager.init(operationQueues: operationQueues)
        self.operationQueueManager = operationQueueManager
        //
        // End manager //
        
        
        // API //
        let apiJWT: MDAPIJWTProtocol = MDAPIJWT.init(requestDispatcher: requestDispatcher,
                                                     operationQueue: operationQueueManager.operationQueue(byName: MDConstants.QueueName.jwtAPIOperationQueue)!)
        self.apiJWT = apiJWT
        //
        let apiUser: MDAPIUserProtocol = MDAPIUser.init(requestDispatcher: requestDispatcher,
                                                        operationQueue: operationQueueManager.operationQueue(byName: MDConstants.QueueName.userAPIOperationQueue)!)
        self.apiUser = apiUser
        //
        let apiLanguage: MDAPILanguageProtocol = MDAPILanguage.init(requestDispatcher: requestDispatcher,
                                                                    operationQueue: operationQueueManager.operationQueue(byName: MDConstants.QueueName.languageAPIOperationQueue)!)
        self.apiLanguage = apiLanguage
        //
        let apiCourse: MDAPICourseProtocol = MDAPICourse.init(requestDispatcher: requestDispatcher,
                                                              operationQueue: operationQueueManager.operationQueue(byName: MDConstants.QueueName.courseAPIOperationQueue)!)
        self.apiCourse = apiCourse
        //
        let apiWord: MDAPIWordProtocol = MDAPIWord.init(requestDispatcher: requestDispatcher,
                                                        operationQueue: operationQueueManager.operationQueue(byName: MDConstants.QueueName.wordAPIOperationQueue)!)
        self.apiWord = apiWord
        //
        let apiAuth: MDAPIAuthProtocol = MDAPIAuth.init(requestDispatcher: requestDispatcher,
                                                        operationQueue: operationQueueManager.operationQueue(byName: MDConstants.QueueName.authAPIOperationQueue)!)
        self.apiAuth = apiAuth
        //
        let apiAccount: MDAPIAccountProtocol = MDAPIAccount.init(requestDispatcher: requestDispatcher,
                                                                 operationQueue: operationQueueManager.operationQueue(byName: MDConstants.QueueName.accountAPIOperationQueue)!)
        self.apiAccount = apiAccount
        //
        // END API //
        
        
        // Storage //
        // JWT //
        let jwtMemoryStorage: MDJWTMemoryStorageProtocol = MDJWTMemoryStorage.init(operationQueue: operationQueueManager.operationQueue(byName: MDConstants.QueueName.jwtMemoryStorageOperationQueue)!,
                                                                                   array: .init())
        
        let jwtCoreDataStorage: MDJWTCoreDataStorageProtocol = MDJWTCoreDataStorage.init(operationQueue: operationQueueManager.operationQueue(byName: MDConstants.QueueName.jwtCoreDataStorageOperationQueue)!,
                                                                                         managedObjectContext: coreDataStack.privateContext,
                                                                                         coreDataStack: coreDataStack)
        
        let jwtStorage: MDJWTStorageProtocol = MDJWTStorage.init(memoryStorage: jwtMemoryStorage,
                                                                 coreDataStorage: jwtCoreDataStorage)
        
        self.jwtStorage = jwtStorage
        // End JWT //
        
        // User //
        let userMemoryStorage: MDUserMemoryStorageProtocol = MDUserMemoryStorage.init(operationQueue: operationQueueManager.operationQueue(byName: MDConstants.QueueName.userMemoryStorageOperationQueue)!,
                                                                                      array: .init())
        
        let userCoreDataStorage: MDUserCoreDataStorageProtocol = MDUserCoreDataStorage.init(operationQueue: operationQueueManager.operationQueue(byName: MDConstants.QueueName.userCoreDataStorageOperationQueue)!,
                                                                                            managedObjectContext: coreDataStack.privateContext,
                                                                                            coreDataStack: coreDataStack)
        
        let userStorage: MDUserStorageProtocol = MDUserStorage.init(memoryStorage: userMemoryStorage,
                                                                    coreDataStorage: userCoreDataStorage)
        
        self.userStorage = userStorage
        // End User //
        
        // Language //
        let languageMemoryStorage: MDLanguageMemoryStorageProtocol = MDLanguageMemoryStorage.init(operationQueue: operationQueueManager.operationQueue(byName: MDConstants.QueueName.languageMemoryStorageOperationQueue)!,
                                                                                                  array: .init())
        
        let languageCoreDataStorage: MDLanguageCoreDataStorageProtocol = MDLanguageCoreDataStorage.init(operationQueue: operationQueueManager.operationQueue(byName: MDConstants.QueueName.languageCoreDataStorageOperationQueue)!,
                                                                                                        managedObjectContext: coreDataStack.privateContext,
                                                                                                        coreDataStack: coreDataStack)
        
        let languageStorage: MDLanguageStorageProtocol = MDLanguageStorage.init(memoryStorage: languageMemoryStorage,
                                                                                coreDataStorage: languageCoreDataStorage)
        
        self.languageStorage = languageStorage
        // End Language //
        
        // Language //
        let courseMemoryStorage: MDCourseMemoryStorageProtocol = MDCourseMemoryStorage.init(operationQueue: operationQueueManager.operationQueue(byName: MDConstants.QueueName.courseMemoryStorageOperationQueue)!,
                                                                                            array: .init())
        
        let courseCoreDataStorage: MDCourseCoreDataStorageProtocol = MDCourseCoreDataStorage.init(operationQueue: operationQueueManager.operationQueue(byName: MDConstants.QueueName.courseCoreDataStorageOperationQueue)!,
                                                                                                  managedObjectContext: coreDataStack.privateContext,
                                                                                                  coreDataStack: coreDataStack)
        
        let courseStorage: MDCourseStorageProtocol = MDCourseStorage.init(memoryStorage: courseMemoryStorage,
                                                                          coreDataStorage: courseCoreDataStorage)
        
        self.courseStorage = courseStorage
        // End Language //
        
        // Word //
        let wordMemoryStorage: MDWordMemoryStorageProtocol = MDWordMemoryStorage.init(operationQueue: operationQueueManager.operationQueue(byName: MDConstants.QueueName.wordMemoryStorageOperationQueue)!,
                                                                                      arrayWords: .init())
        
        let wordCoreDataStorage: MDWordCoreDataStorageProtocol = MDWordCoreDataStorage.init(operationQueue: operationQueueManager.operationQueue(byName: MDConstants.QueueName.wordCoreDataStorageOperationQueue)!,
                                                                                            managedObjectContext: coreDataStack.privateContext,
                                                                                            coreDataStack: coreDataStack)
        
        let wordStorage: MDWordStorageProtocol = MDWordStorage.init(memoryStorage: wordMemoryStorage,
                                                                    coreDataStorage: wordCoreDataStorage)
        
        self.wordStorage = wordStorage
        // End Word //
        // End Storage //
        
        let userDefaults: UserDefaults = .standard
        let appSettings: MDAppSettingsProtocol = MDAppSettings.init(userDefaults:userDefaults )
        self.appSettings = appSettings
        
        //
        // Bridge
        let bridge: MDBridgeProtocol = MDBridge.init()
        self.bridge = bridge
        //
        //
        
        //
        // Fill Memory Service
        let fillMemoryService: MDFillMemoryServiceProtocol = MDFillMemoryService.init(isLoggedIn: appSettings.isLoggedIn,
                                                                                      jwtStorage: jwtStorage,
                                                                                      userStorage: userStorage,
                                                                                      languageStorage: languageStorage,
                                                                                      courseStorage: courseStorage,
                                                                                      wordStorage: wordStorage,
                                                                                      bridge: bridge)
        // Fill Memory If Needed
        fillMemoryService.fillMemoryFromCoreDataIfNeeded(completionHandler: nil)
        //
        self.fillMemoryService = fillMemoryService
        //
        //
        
        // Configure FirebaseApp
        FirebaseApp.configure()
        
    }
    
}

// MARK: - Private Methods
fileprivate extension MDAppDependencies {
    
    func createOperationQueue(byName name: String) -> OperationQueue {
        let operationQueue: OperationQueue = .init()
        operationQueue.name = name
        return operationQueue
    }
    
}
