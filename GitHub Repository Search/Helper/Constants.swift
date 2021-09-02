//
//  Constants.swift
//  GitHub Repository Search
//
//  Created by Haresh Ghatala on 2021/09/01.
//

public let githubBaseURLString = "https://api.github.com/search"

public let apiDataLimit = 40
public let maxPageLimit = 25

public let repoItemCellId = "RepoItemTableViewCell"
public let searchHistoryCellId = "SearchHistoryCell"

public let emptyValue = " - - - "
public let repoDetailsSegueId = "ShowRepositoryDetailsSegue"

public let searchHistoryPlistFile = "SearchHistory.plist"
public let searchHistoryLimit = 20

public let searchMinCharValidationMsg = "Type in at least 3 characters to search."
public let infoMsgNoImgFound = "No results found."
public let errorMsgInvalidEndpoint = "Invalid URL or Endpoint. Please retry."
public let errorMsgInvalidResponse = "Invalid response or Data issue. Please retry."
public let errorMsgUnknown = "Unknown Error. Please retry."
