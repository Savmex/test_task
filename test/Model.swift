import UIKit

struct SearchItem{
    var url: String
    var title: String
}

struct ErrorMessages{
    let noTextInLabelError = "Enter text"
    let errorGettingData = "Error getting data"
}

struct KeysForFetchedDataDictionaries {
    let keyForItems = "items"
    let keyForURL = "formattedUrl"
    let keyForTitle = "title"
}

class ColorsForViewControllerElements{
    static let colors = ColorsForViewControllerElements()
    let colorForNormalButtonState = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
    let colorForProgressViewProgress = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
    let colorForSeparatingLines = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
    let colorForPressedButtonState = UIColor.red.withAlphaComponent(0.8)
    let colorForToastMessageBackground = UIColor.black.withAlphaComponent(0.6)
    let colorForToastMessageText = UIColor.white
}

class SearchButtonStatesTitles{
    static let titles = SearchButtonStatesTitles()
    let titleForNormalState = "Google Search"
    let titleForPressedState = "Stop"
}

struct HeightsAndOffsetsForVCElements{
     let topOffsetForLabelContainerView = UIApplication.shared.windows[0].safeAreaInsets.top
     let heightForLabelContainerView = CGFloat(40)
     let heightForButtonContainerView = CGFloat(42)
     let heightForProgressViewContainerView = CGFloat(2)
     let topOffsetForProgressViewContainerView = CGFloat(1)
     let topOffsetForTableView = CGFloat(1)
     let bottomOffsetForTableView = UIApplication.shared.windows[0].safeAreaInsets.bottom
     let heightForSeparatingLines = CGFloat(1)
     let heightForSearchLabel = CGFloat(38)
     let horizontalOffsetForLabel = CGFloat(20)
     let topOffsetForSearchButton = CGFloat(2)
     let horizontalOffsetForSearchButton = CGFloat(70)
     let heightForSearchButton = CGFloat(38)
     let bottomOffsetForSearchButton = CGFloat(2)
     let heightForTableViewRow = CGFloat(60)
     let widthForToastMessage = CGFloat(150)
     let heightForToastMessage = CGFloat(35)
}

struct HeightsAndOffsetsForSearchResultCell{
     let topOffsetForTitleLabel = CGFloat(2)
     let horizontalOffsetForTitleLabel = CGFloat(2)
     let heightForTitleLabel = CGFloat(30)
     let topOffsetForLinkLabel = CGFloat(2)
     let horizontalOffsetForLinkLabel = CGFloat(3)
     let heightForLinkLabel = CGFloat(24)
}

class FontSizesForSearchResultCell{
    static let sizes = FontSizesForSearchResultCell()
    let fontSizeForTitleLabel = CGFloat(16)
    let fontSizeForLinkLabel = CGFloat(14)
}

class ColorsForSearchResultCell{
    static let colors = ColorsForSearchResultCell()
    let colorForLabelForTitle = UIColor.black
    let colorForLabelForLink = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
}

