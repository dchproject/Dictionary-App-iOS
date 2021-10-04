//
//  MDCourseMemoryStorage.swift
//  MyDictionary_App_Swift
//
//  Created by Dmytro Chumakov on 23.08.2021.
//

import Foundation

protocol MDCourseMemoryStorageProtocol: MDCRUDCourseProtocol,
                                        MDStorageInterface {
    
}

final class MDCourseMemoryStorage: MDCourseMemoryStorageProtocol {
    
    fileprivate let operationQueue: OperationQueue
    
    var array: [CourseResponse]
    
    init(operationQueue: OperationQueue,
         array: [CourseResponse]) {
        
        self.operationQueue = operationQueue
        self.array = array
        
    }
    
    deinit {
        debugPrint(#function, Self.self)
    }
    
}

// MARK: - Entities
extension MDCourseMemoryStorage {
    
    func entitiesCount(_ completionHandler: @escaping (MDEntitiesCountResultWithCompletion)) {
        self.readAllCourses { result in
            switch result {
            case .success(let entities):
                completionHandler(.success(entities.count))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func entitiesIsEmpty(_ completionHandler: @escaping (MDEntitiesIsEmptyResultWithCompletion)) {
        self.readAllCourses { result in
            switch result {
            case .success(let entities):
                completionHandler(.success(entities.isEmpty))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
}

// MARK: - CRUD
extension MDCourseMemoryStorage {
    
    func createCourse(_ courseEntity: CourseResponse, _ completionHandler: @escaping (MDOperationResultWithCompletion<CourseResponse>)) {
        let operation: MDCreateCourseMemoryStorageOperation = .init(memoryStorage: self,
                                                                    courseEntity: courseEntity) { result in
            completionHandler(result)
        }
        operationQueue.addOperation(operation)
    }
    
    func createCourses(_ courseEntities: [CourseResponse], _ completionHandler: @escaping (MDOperationsResultWithCompletion<CourseResponse>)) {
        let operation: MDCreateCoursesMemoryStorageOperation = .init(memoryStorage: self,
                                                                     courseEntities: courseEntities) { result in
            completionHandler(result)
        }
        operationQueue.addOperation(operation)
    }
    
    func readCourse(fromCourseId courseId: Int64, _ completionHandler: @escaping (MDOperationResultWithCompletion<CourseResponse>)) {
        let operation: MDReadCourseMemoryStorageOperation = .init(memoryStorage: self,
                                                                  courseId: courseId) { result in
            completionHandler(result)
        }
        operationQueue.addOperation(operation)
    }
    
    func readAllCourses(_ completionHandler: @escaping (MDOperationResultWithCompletion<[CourseResponse]>)) {
        let operation: MDReadAllCoursesMemoryStorageOperation = .init(memoryStorage: self) { result in
            completionHandler(result)
        }
        operationQueue.addOperation(operation)
    }
    
    func deleteCourse(fromCourseId courseId: Int64, _ completionHandler: @escaping (MDOperationResultWithCompletion<Void>)) {
        let operation: MDDeleteCourseMemoryStorageOperation = .init(memoryStorage: self,
                                                                    courseId: courseId) { result in
            completionHandler(result)
        }
        operationQueue.addOperation(operation)
    }
    
    func deleteAllCourses(_ completionHandler: @escaping (MDOperationResultWithCompletion<Void>)) {
        let operation: MDDeleteAllCoursesMemoryStorageOperation = .init(memoryStorage: self) { result in
            completionHandler(result)
        }
        operationQueue.addOperation(operation)
    }
    
}
