//
//  AppearanceRowModel.swift
//  MyDictionary_App_Swift
//
//  Created by Dmytro Chumakov on 05.06.2021.
//

import UIKit

struct AppearanceRowModel: AppearanceTypePropertyProtocol {
    
    let titleText: String
    let rowType: AppearanceRowType
    var isSelected: Bool
    var appearanceType: AppearanceType
    
}