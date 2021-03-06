//
//  PrivacyPolicyViewController.swift
//  MyDictionary_App_Swift
//
//  Created Dmytro Chumakov on 21.09.2021.

import UIKit

final class PrivacyPolicyViewController: MDBaseTitledBackNavigationBarWebViewController {
    
    init() {        
        super.init(url: MDConstants.StaticURL.privacyPolicyURL,
                   title: MDLocalizedText.privacyPolicy.localized,
                   navigationBarBackgroundImage: MDUIResources.Image.background_navigation_bar_2.image)
    }
    
    deinit {
        debugPrint(#function, Self.self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
