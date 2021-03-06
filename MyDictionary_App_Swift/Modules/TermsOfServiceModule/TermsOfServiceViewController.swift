//
//  TermsOfServiceViewController.swift
//  MyDictionary_App_Swift
//
//  Created by Dmytro Chumakov on 21.09.2021.
//

import UIKit

final class TermsOfServiceViewController: MDBaseTitledBackNavigationBarWebViewController {
    
    init() {
        super.init(url: MDConstants.StaticURL.termsOfServiceURL,
                   title: MDLocalizedText.termsOfService.localized,
                   navigationBarBackgroundImage: MDUIResources.Image.background_navigation_bar_2.image)
    }
    
    deinit {
        debugPrint(#function, Self.self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

