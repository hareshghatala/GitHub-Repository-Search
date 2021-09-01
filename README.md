# GitHub Repository Search API using MVVM
This repository demonstrates the GitHub Repository search API and demonstrates MVVM architecture with Swift.  

This demo application which allows the user to search through GitHub open source repositories. The app allows user to search phrase and list which displays the search results and on selecting item the website of the repository will be displayed in a web browser.

This demo app contains search list. When opening the app, user allow to search GitHub open source repositories. All images are fetched from GitHub's API with `search/repositories` endpoint. It allows users to search the images as per his/her need and show past search history for quick search.
- Loading and error states are handled using observable closure.
- Images are cached for better performance.
- ViewModel & View bounded using swift closure.
- UI refreshed with the data update.
- Added pagination _(infinite scrolling)_ to the image lists.
- Provides history of past search terms _(latest 20 items are provided)_

## Technical Specification

>  - [x] Xcode 12 and later 
>  - [x] iOS 13.0 and later
>  - [x] Swift 5
>  - [x] iPhone only app
>  - [x] Swift & Storyboard

### Architecture
MVVM *(Model View ViewModel)*

### Cocoa Pods Used
Didn't used any dependency.


### API provider
GitHub repository search API information can be found at: 
`https://developer.github.com/v3/search`


---------- 

## Communication

-   If you  **want to contribute**, submit a pull request.
-   For any qustion or suggetions, you can create issue for it. Enjoy The Coding !!!
