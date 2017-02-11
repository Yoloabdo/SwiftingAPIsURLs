//: Playground - noun: a place where people can play

import UIKit

struct AppLinks {
    static let MainDomain = "www.sdfasd.asdf"
    static let SubDomainChat = MainDomain.appending("/chat")
}

enum Paths: String {
    case mainStream = "path"
    case profileGame = "profileGame"
    case follow = "follow"
}


enum URLsFactory{
    case getWithPaging(Paths, page: Int, limit: Int)
    case appSimple(Paths)
    case chat(Paths)
    
    var link: URL {
        switch self {
        case .getWithPaging(let path, let page, let limit):
            return URL(string: "\(AppLinks.MainDomain)/\(path.rawValue)?page=\(page)&limit=\(limit)")!
        case .appSimple(let path):
            return URL(string: "\(AppLinks.MainDomain)/\(path.rawValue)")!
        case .chat(let path):
            return URL(string: "\(AppLinks.SubDomainChat)/\(path.rawValue)")!
        }
    }
}


let x = URLsFactory.getWithPaging(.mainStream, page: 15, limit: 15).link



