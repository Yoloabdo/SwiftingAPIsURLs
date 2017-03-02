//: Playground - noun: a place where people can play

import UIKit


// two cases that we need urls to be build upon
enum URLsFactory {
    case simpleCall(Paths, page: Int, limit: Int)
    case appSimple(Paths)
    
}

// api paths
extension URLsFactory{
    enum Paths: String {
        case mainStream = "path"
        case profileGame = "profileGame"
        case follow = "follow"
    }
}

// url builder
extension URLsFactory {
    var url: URL {
        switch self {
        case .simpleCall(let path, let page, let limit):
            return URL(string: "\(mainDomain)/\(path.rawValue)?page=\(page)&limit=\(limit)")!
        case .appSimple(let path):
            return URL(string: "\(mainDomain)/\(path.rawValue)")!
        }
    }
}

// main webservice url
extension URLsFactory{
    var mainDomain: String {
        return "www.example.com"
    }
}

let urlWithPaging = URLsFactory.simpleCall(.mainStream, page: 15, limit: 15).url
let url = URLsFactory.appSimple(.profileGame).url



