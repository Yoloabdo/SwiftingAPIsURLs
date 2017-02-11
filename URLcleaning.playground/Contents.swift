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
    case app(Paths,Int,Int)
    case appSimple(Paths)
    case chat(Paths)
    
    var link: URL {
        switch self {
        case .app(let path, let page, let limit):
            return URL(string: "\(AppLinks.MainDomain)/\(path.rawValue)?page=\(page)&limit=\(limit)")!
        case .appSimple(let path):
            return URL(string: "\(AppLinks.MainDomain)/\(path.rawValue)")!
        case .chat(let path):
            return URL(string: "\(AppLinks.SubDomainChat)/\(path.rawValue)")!
        }
    }
}


let x = URLsFactory.app(.mainStream, 15, 15).link



