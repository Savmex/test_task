import UIKit
import WebKit

/**
 View controller for displaying web content.
*/
class WebPageViewController: UIViewController, WKNavigationDelegate {

    /**
     View that represents web content
    */
    @IBOutlet weak var webView: WebPageView!
    /**
     Indicates content loading
    */
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let operationQueue = OperationQueue()
    private let toastMessageView = ToastMessageView()
    private var item: WebPageInfoItem?
    
    /**
     Handles additional initialization.
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do{
            webView.navigationDelegate = self
            try loadWebPage()
        }
        catch let error {
            handleError(error: error)
        }
    }
    
    private func startActivityAnimation() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }
    
    private func stopActivityAnimation() {
        activityIndicator.stopAnimating()
    }
    /**
     Called when WebPageView begins loading content.
    */
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        startActivityAnimation()
    }
    
    /**
     Called when WebPageView finishs loading content.
     */
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        stopActivityAnimation()
    }

    private func loadWebPage() throws {
        do{
            guard let title = item?.title else { throw WebPageVCErrors.noTitle }
            self.title = title
            guard let url = item?.url  else { throw WebPageVCErrors.wrongURl }
            try self.webView.loadPageWith(url: url)
        }
    }
    
    private func handleError(error: Error) {
        if let webPageError = error as? WebPageVCErrors{
            switch webPageError{
            case WebPageVCErrors.wrongURl:
                toastMessageView.showToast(with: "\(WebPageVCErrors.wrongURl)", for: self)
            case WebPageVCErrors.noTitle:
                toastMessageView.showToast(with: "\(WebPageVCErrors.noTitle)", for: self)
            }
        }
        else{
            toastMessageView.showToast(with: error.localizedDescription, for: self)
        }
        navigationController?.popViewController(animated: true)
    }
    /**
     Set's the info object with data to display
    */
    func setWebPageInfo(info: WebPageInfoItem) {
        self.item = info
    }
    
}
