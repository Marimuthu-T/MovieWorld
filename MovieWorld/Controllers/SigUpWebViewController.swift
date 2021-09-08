//
//  SigUpWebViewController.swift
//  MovieWorld
//
//  Created by Marimuthu T on 08/09/21.
//

import UIKit
import WebKit

class SigUpWebViewController: UIViewController , UIWebViewDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var pageLoadActivityView: UIActivityIndicatorView!
    var webView = WKWebView()
    
    var url = URL(string: "https://www.themoviedb.org/signup")!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.navigationDelegate = self
        webView.addSubview(pageLoadActivityView)
        loadWebView()
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        pageLoadActivityView.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        pageLoadActivityView.stopAnimating()
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        webView.frame = self.view.bounds
    }
    
    
    private func loadWebView()
    {
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        self.view = webView
    }
    
    
    

}
