//
//  MDCreateCourseProtocol.swift
//  MyDictionary_App_Swift
//
//  Created by Dmytro Chumakov on 23.08.2021.
//

import Foundation

protocol MDCreateCourseProtocol {
    func createCourse(_ courseEntity: CourseResponse, _ completionHandler: @escaping(MDOperationResultWithCompletion<CourseResponse>))
    func createCourses(_ courseEntities: [CourseResponse], _ completionHandler: @escaping(MDOperationsResultWithCompletion<CourseResponse>))
}
