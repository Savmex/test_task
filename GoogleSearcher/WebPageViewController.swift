import UIKit
import WebKit

class WebPageViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    private let operationQueue = OperationQueue()
    
    private let toastMessageView = ToastMessageView()
    private var url = String()
    private let activityIndicator = UIActivityIndicatorView(style: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        do{
            activityIndicator.center = view.center
            view.addSubview(activityIndicator)
            activityIndicator.isHidden = true
            try loadWebPage()
        }
        catch let error {
            handleError(error: error)
        }
    }
    
    private func startActivityAnimation() {
        OperationQueue.main.addOperation {
            self.activityIndicator.hidesWhenStopped = true
            self.activityIndicator.startAnimating()
        }
    }
    
    private func stopActivityAnimation() {
        OperationQueue.main.addOperation {
            self.activityIndicator.stopAnimating()
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        startActivityAnimation()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        stopActivityAnimation()
    }
    
    private func loadWebPage() throws {
        guard let pageUrl = URL(string: self.url) else{ return }
        let urlRequest = URLRequest(url: pageUrl)
        self.webView.load(urlRequest)
    }
    
    private func handleError(error: Error) {
        if let webPageError = error as? WebPageVCErrors{
            switch webPageError{
            case WebPageVCErrors.wrongURl:
                toastMessageView.showToast(with: "\(WebPageVCErrors.wrongURl)", for: self)
            }
        }
        else{
            toastMessageView.showToast(with: error.localizedDescription, for: self)
        }
    }
    
    /**
     Sets url of web page to show
    */
    func setURL(url: String) {
        self.url = url
    }
    
    /**
     Sets title of web page to show
    */
    func setTitle(title: String) {
        self.title = title
    }
    
}
