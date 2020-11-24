//
//  BaseWebViewController.swift
//
//  Created by Manoj Karki on 3/16/18.
//

import UIKit
import WebKit

class BaseWebViewController: BaseViewController {
    
    fileprivate var observerKeys = ["loading", "estimatedProgress"]
    
    var onFinished: VoidClosure = nil

    fileprivate let backImage = "back"

    var webView: WKWebView!
    
    fileprivate lazy var progressBar: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = IMColor.redThemeColor.value
        return progressView
    }()

    required init?(coder aDecoder: NSCoder) {
        let webConfiguration = WKWebViewConfiguration()
        
        let wkPreference = WKPreferences.init()
        wkPreference.javaScriptEnabled = true
        
        webConfiguration.preferences = wkPreference
        webView = WKWebView.init(frame: .zero, configuration: webConfiguration)

        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        addBackButton()

        view.addSubview(progressBar)
        view.insertSubview(webView, belowSubview: progressBar)
        addConstraints()
        
        webView.navigationDelegate = self
        observe()
    }

    private func addConstraints() {
        
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0.0).isActive = true
        progressBar.heightAnchor.constraint(equalToConstant: 3.0).isActive = true
        progressBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive = true
    
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
    }
    
    private func addBackButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: backImage) , style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonClicked))
    }

    private func addBlackBackButton() {
      navigationItem.leftBarButtonItem = UIBarButtonItem.init(image:UIImage.init(named: backImage) , style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonClicked))
    }

    @objc private func backButtonClicked() {
        
        if webView.backForwardList.backList.count > 0 {
            webView.goBack()
            return
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        guard let keyPath = keyPath else { return }
        
        switch keyPath {
        case "loading":
            //navigationItem.leftBarButtonItem?.isEnabled = webView.canGoBack
            break
        case "estimatedProgress":
            progressBar.isHidden = webView.estimatedProgress == 1
            progressBar.setProgress(Float(webView.estimatedProgress), animated: true)
            break
        default:
            break
        }
    }

    deinit {
        stopObserving()
    }
}

private extension BaseWebViewController {
    
    func observe() {
        for path in observerKeys {
            webView.addObserver(self, forKeyPath: path, options: .new, context: nil)
        }
    }
    
    func stopObserving() {
        for path in observerKeys {
            webView.removeObserver(self, forKeyPath: path)
        }
    }
}

extension BaseWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.progressBar.setProgress(0.0, animated: true)
        onFinished?()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //print("Loading started")
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        //print("Content Loaded \(navigation.description)")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        //print("Did fail ")
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        onFinished?()
        showAlert(title: "Error!", message: error.localizedDescription)
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        //print("CONTENT PROCEED TERMINATED")
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
//    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//
//        if(challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust)
//        {
//            let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
//            completionHandler(.useCredential, cred)
//        }
//        else
//        {
//            completionHandler(.performDefaultHandling, nil)
//        }
//
//    }
}
