//: Playground - noun: a place where people can play

import UIKit



enum URLsFactory{
    
    enum WebService: String {
        case MainDomain = "www.example.com"
    }
    
    enum Paths: String {
        case mainStream = "path"
        case profileGame = "profileGame"
        case follow = "follow"
    }
    
    case getWithPaging(Paths, page: Int, limit: Int)
    case appSimple(Paths)
    case chat(Paths)
    
    var link: URL {
        switch self {
        case .getWithPaging(let path, let page, let limit):
            return URL(string: "\(WebService.MainDomain.rawValue)/\(path.rawValue)?page=\(page)&limit=\(limit)")!
        case .appSimple(let path):
            return URL(string: "\(WebService.MainDomain.rawValue)/\(path.rawValue)")!
        case .chat(let path):
            return URL(string: "\(WebService.MainDomain.rawValue)/\(path.rawValue)")!
        }
    }
}


let x = URLsFactory.getWithPaging(.mainStream, page: 15, limit: 15).link



