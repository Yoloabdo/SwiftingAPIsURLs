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
    case app(Paths)
    case chat(Paths)
    
    var link: URL {
        switch self {
        case .app(let path):
            return URL(string: "\(AppLinks.MainDomain)/\(path.rawValue)")!
        case .chat(let path):
            return URL(string: "\(AppLinks.SubDomainChat)/\(path.rawValue)")!
        }
    }
}


URLsFactory.app(.mainStream).link


