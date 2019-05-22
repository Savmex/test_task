import Foundation
import WebKit

/**
 Custom view for
 */
class WebPageView: UIView {
    
    @IBOutlet weak var webView: WKWebView!
    
    private let nibName = "WebPageView"
    /**
    The WebPageView's navigation delegate.
    */
    var navigationDelegate: WKNavigationDelegate?{
        didSet{
            webView.navigationDelegate = navigationDelegate
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    private func setUp(){
        let view = loadFromNib()
        view.frame = bounds
        addSubview(view)
    }
    
    private func loadFromNib() -> UIView {
        var view = UIView()
        if let viewFromNib = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView{
            view = viewFromNib
        }
        return view
    }
    
    /**
     Tells object to load and display url's content
    */
    
    func loadPageWith(url: String) throws {
        guard let pageUrl = URL(string: url) else{ throw  WebPageVCErrors.wrongURl}
        let urlRequest = URLRequest(url: pageUrl)
        self.webView.load(urlRequest)
    }
    
}
