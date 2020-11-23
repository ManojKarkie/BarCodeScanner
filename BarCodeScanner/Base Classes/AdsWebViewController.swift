//
//  AdsWebViewController.swift
//  IMEPayWallet
//
//  Created by Manoj Karki on 1/10/18.
//  Copyright © 2018 imedigital. All rights reserved.
//

import UIKit
import WebKit

//MARK:-

class AdsWebViewController: BaseWebViewController, StoryboardInitializable {

    var urlString: String?
    var viewTitle: String?



    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let urlstring = urlString, let url = URL(string: urlstring)  {
           self.webView.load(URLRequest(url: url))
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = viewTitle
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK:- Web View to show Terms and Conditions and Privacy Policy etc.

class AppInfoWebViewController : BaseWebViewController, StoryboardInitializable {

    var urlString: String?
    var viewTitle: String?

    @IBOutlet weak var shadowLine: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        addDissmissBtn()
        // Do any additional setup after loading the view.
        if let urlstring = urlString, let url = URL(string: urlstring)  {
            self.webView.load(URLRequest(url: url))
        }

        onFinished = {
            self.view.bringSubviewToFront(self.shadowLine)
        }
    }

    func addDissmissBtn() {
        let cancelBtn = UIBarButtonItem(image: UIImage(named:"close_small"), style: .plain, target: self, action:#selector(dissmissWebView))
        cancelBtn.tintColor = UIColor.black
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = cancelBtn
    }

    @objc func dissmissWebView() {
        self.navigationController?.dissmiss()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = viewTitle
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
