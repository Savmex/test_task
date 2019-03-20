import UIKit

/*
 класс SearchProgressView включает в себя progressView и методы для установки значения progress, используется для отображения прогресса по загрузке данных 
 */
class SearchProgressView: UIView {
    
    private let progressView = UIProgressView(progressViewStyle: .default)
    private let valueForStartLoading = Float(0.3)
    private let valueForLoadingData = Float(0.7)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews(){
        addSubview(progressView)
        
        setUpProgressView()
        createProgressViewConstraints()
    }
    
    private func setUpProgressView(){
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.trackTintColor = UIColor.white
        progressView.progressTintColor = ColorsForViewControllerElements.colors.colorForProgressViewProgress
        progressView.isHidden = true
    }
    
    private func createProgressViewConstraints(){
        progressView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        progressView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        progressView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        progressView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }
    
    //используется классом ViewController для установки значения соответствующего текущему прогрессу по запросу
    func setStartLoadingProgressValue(){
        progressView.setProgress(valueForStartLoading, animated: true)
    }
    
    //используется классом ViewController для установки значения соответствующего текущему прогрессу по запросу
    func setLoadingDataProgressValue(){
        progressView.setProgress(valueForLoadingData, animated: true)
    }
    //используется классом ViewController для скрытия этого view когда он не требуется
    func isProgressViewHidden(_ result: Bool){
        switch result {
        case true:
            progressView.isHidden = true
        default:
            progressView.isHidden = false
        }
    }
}
