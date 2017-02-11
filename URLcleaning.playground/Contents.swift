//: Playground - noun: a place where people can play

import UIKit

struct appLinks {
    static let MainDomain = "www.sdfasd.asdf"
    static let SubDomainChat = MainDomain.appending("/chat")
}

enum paths: String {
    case mainStream = "path"
    case profileGame = "profileGame"
    case follow = "follow"
}


enum URLsFactory{
    case app(paths)
    case chat(paths)
    
    var link: URL {
        switch self {
        case .app(let path):
            return URL(string: "\(appLinks.MainDomain)/\(path.rawValue)")!
        case .chat(let path):
            return URL(string: "\(appLinks.SubDomainChat)/\(path.rawValue)")!
        }
    }
}


URLsFactory.app(.mainStream).link


