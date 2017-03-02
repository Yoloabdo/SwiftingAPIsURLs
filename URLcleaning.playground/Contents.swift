//: Playground - noun: a place where people can play

import UIKit



enum URLsFactory{
    case simpleCall(Paths, page: Int, limit: Int)
    case appSimple(Paths)
    
    var url: URL {
        switch self {
        case .simpleCall(let path, let page, let limit):
            return URL(string: "\(mainDomain)/\(path.rawValue)?page=\(page)&limit=\(limit)")!
        case .appSimple(let path):
            return URL(string: "\(mainDomain)/\(path.rawValue)")!
        }
    }
    
    enum Paths: String {
        case mainStream = "path"
        case profileGame = "profileGame"
        case follow = "follow"
    }
    
    var mainDomain: String {
        return "www.example.com"
    }
}


let urlWithPaging = URLsFactory.simpleCall(.mainStream, page: 15, limit: 15).url
let url = URLsFactory.appSimple(.profileGame).url





