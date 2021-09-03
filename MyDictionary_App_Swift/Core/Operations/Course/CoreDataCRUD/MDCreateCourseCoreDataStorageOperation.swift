//
//  MDCreateCourseCoreDataStorageOperation.swift
//  MyDictionary_App_Swift
//
//  Created by Dmytro Chumakov on 24.08.2021.
//

import CoreData

final class MDCreateCourseCoreDataStorageOperation: MDOperation {
    
    fileprivate let managedObjectContext: NSManagedObjectContext
    fileprivate let coreDataStack: CoreDataStack
    fileprivate let coreDataStorage: MDCourseCoreDataStorage
    fileprivate let courseEntity: CourseResponse
    fileprivate let result: MDOperationResultWithCompletion<CourseResponse>?
    
    init(managedObjectContext: NSManagedObjectContext,
         coreDataStack: CoreDataStack,
         coreDataStorage: MDCourseCoreDataStorage,
         courseEntity: CourseResponse,
         result: MDOperationResultWithCompletion<CourseResponse>?) {
        
        self.managedObjectContext = managedObjectContext
        self.coreDataStack = coreDataStack
        self.coreDataStorage = coreDataStorage
        self.courseEntity = courseEntity
        self.result = result
        
        super.init()
    }
    
    override func main() {
        
        let newCourseEntity = CDCourseResponseEntity.init(courseResponse: self.courseEntity,
                                                          insertIntoManagedObjectContext: self.managedObjectContext)
        
        do {
            
            try coreDataStack.save()
            
            DispatchQueue.main.async {
                self.result?(.success((newCourseEntity.courseResponse)))
                self.finish()
            }
            
        } catch {
            self.result?(.failure(error))
            self.finish()
        }
        
    }
    
    deinit {
        debugPrint(#function, Self.self)
        self.finish()
    }
    
}

final class MDCreateCoursesCoreDataStorageOperation: MDOperation {
    
    fileprivate let managedObjectContext: NSManagedObjectContext
    fileprivate let coreDataStack: CoreDataStack
    fileprivate let coreDataStorage: MDCourseCoreDataStorage
    fileprivate let courseEntities: [CourseResponse]
    fileprivate let result: MDOperationsResultWithCompletion<CourseResponse>?
    
    init(managedObjectContext: NSManagedObjectContext,
         coreDataStack: CoreDataStack,
         coreDataStorage: MDCourseCoreDataStorage,
         courseEntities: [CourseResponse],
         result: MDOperationsResultWithCompletion<CourseResponse>?) {
        
        self.managedObjectContext = managedObjectContext
        self.coreDataStack = coreDataStack
        self.coreDataStorage = coreDataStorage
        self.courseEntities = courseEntities
        self.result = result
        
        super.init()
    }
    
    override func main() {
        
        if (self.courseEntities.isEmpty) {
            self.result?(.success(self.courseEntities))
            self.finish()
        } else {
            
            var resultCount: Int = .zero
            
            self.courseEntities.forEach { courseEntity in
                
                let _ = CDCourseResponseEntity.init(courseResponse: courseEntity,
                                                    insertIntoManagedObjectContext: self.managedObjectContext)
                
                
                do {
                    
                    try coreDataStack.save()
                    
                    resultCount += 1
                                        
                    if (resultCount == self.courseEntities.count) {
                        
                        DispatchQueue.main.async {
                            self.result?(.success(self.courseEntities))
                        }
                        
                        self.finish()
                        
                    }
                    
                } catch {
                    DispatchQueue.main.async {
                        self.result?(.failure(error))
                    }
                    self.finish()
                }
                
            }
            
        }
        
    }
    
    deinit {
        debugPrint(#function, Self.self)
        self.finish()
    }
    
}
