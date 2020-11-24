//
//  BaseViewController.swift
//
//  Created by Manoj Karki on 10/8/17.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation

class BaseViewController: UIViewController {

    var viewDidAppearFirstTime: Bool = false
    var viewWillAppearFirstTime: Bool = false
    
    

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage.init(named: "back")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
     
    }

    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        if  !viewDidAppearFirstTime {
            viewDidAppearFirstTime = true
            viewDidAppearForFirstTime()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if  !viewWillAppearFirstTime {
            viewWillAppearFirstTime = true
            viewWillAppearForFirstTime()
        }
        
         navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       // stopReachabilityObserver()
    }

    func viewDidAppearForFirstTime() {}
    func viewWillAppearForFirstTime() {}

    func  requestForCurrentLocation() {
        //appDelegate.locationMangager.startUpdatingLoc()
    }

    func currentLocationUpdated(location: CLLocation?) {}


    @available(iOS 10.0, *)
    func triggerHapticFeedback(intensity: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
       
            let generator = UIImpactFeedbackGenerator(style: intensity)
            generator.impactOccurred()
        
    }

}

