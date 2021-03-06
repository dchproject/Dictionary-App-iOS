//
//  MDReadCourseProtocol.swift
//  MyDictionary_App_Swift
//
//  Created by Dmytro Chumakov on 23.08.2021.
//

import Foundation

protocol MDReadCourseProtocol {
    func readCourse(fromCourseId courseId: Int64, _ completionHandler: @escaping(MDOperationResultWithCompletion<CourseResponse>))
    func readAllCourses(_ completionHandler: @escaping(MDOperationResultWithCompletion<[CourseResponse]>))
}
