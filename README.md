![Swifting APIs](https://i.imgur.com/kWaYpua.png)
# (Swifting APIs) handling APIs on swift

[![Development Language](https://img.shields.io/badge/Language-Swift%203%2F4-brightgreen.svg)](https://github.com/apple/swift)
[![Platform](https://img.shields.io/cocoapods/p/AlamofireNetworkActivityIndicator.svg?style=flat)](http://cocoadocs.org/docsets/AlamofireNetworkActivityIndicator)
[![Twitter](https://img.shields.io/badge/Twitter-yoloabdo-blue.svg)](http://twitter.com/Yoloabdo)

Time to take over your API strings. 

## Features

- [X] Easy switch from production to development
- [X] Enum usage at its best!
- [X] No more clattering links through the project
- [x] Better than using constants file that we all know already.
- [x] Very testable

## Requirements

- iOS 8.0+
- Xcode 8.1, 8.2, 8.3, and 9.0
- Swift 3.0, 3.1, 3.2, and 4.0

## Dependencies

- None

---



You start a project and you're calling APIs everywhere, that's what I've seen people do through many projects lately, but it always bugs me, how come there's no better way to handle this? moving all urls into single place that could be modifided easily anytime, from production to changes in apis through cycles of development that would irritates you during development! 


Let's get into it directly :+1: 

First of all, let’s start by putting all app paths in an enum to make calling it easier later via type inference:

```
enum Paths: String {
  case mainStream = "main"
  case profileGame = "profileGame"
  case follow = "follow"
}
```

Now time to build the main enum that we will use everywhere else:

```
enum URLsFactory{
  case simpleCall(Paths)
  case getWithPaging(Paths, page: Int, limit: Int)
}
```

Here we used an enum with associated value to call the apis with, now let’s build the computed variable that we will use to generate the full URL every time:

```
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

}
```
easy so far, right? but did you notice that “mainDomain” as a variable there? where’s it going to be located? remember when we put it in a struct or an infolist before? well, let’s see the full snippet to discover the new way:

```
enum URLsFactory{
    case getWithPaging(Paths, page: Int, limit: Int)
    case appSimple(Paths)
    
    var url: URL {
        switch self {
        case .getWithPaging(let path, let page, let limit):
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
```

See? all in one place, way neater, easier and clearer, isn’t it!

## Enhancements and using URL Swift constructor

Now let's get back to basics. It’s essential to understand parts of any URL, check this image:
![alt text](https://cdn-images-1.medium.com/max/800/1*8B8EbG05mWNhFny5kd-Ucw.png "Very explanatory image from: http://nshipster.com/nsurl/")

I previously used strings concatenation to add API paths to base URL, but I ran into an issue that what if the path has some strings to be encoded? like Arabic words for example? of course there’s a way to encode it then add it to the string and so on, but wait, ain’t there an easier way to do it? turned out that apple did so already for you! Let’s check it out.

Before:
```
var url: URL {
   switch self {
     case .callAPIWithPage(let path, let page):
       return URL(string: "\(mainDomain)/\(path.rawValue)/\(page)")!
   }
}
```
After:
```
var link: URL {
     switch self {
        case .callAPIWithPage(let path, let page):
            return mainDomain.appendingPathComponent(path.rawValue, isDirectory: true).appendingPathComponent(String(page))
  }
}
```

Now that’s better indeed, and your get your URL encoded for you for free, say you add path from user input for search api or anything alike? you’re 100% safe! Another API issue you would face when you’ve query parameters, how to add that? turns out there’s a builder in Foundation to help you too with that! in case you’re using Alamofire you’d easily send those in parameters and Alamofire would do the job for you, but let’s check it out?

Before:
```
var url: URL {
  switch self {
    case .callWithLimit(let path, let page, let limit):
      return URL(string: "\(mainDomain)/\(path.rawValue)?page=\(page)&limit=\(limit)")!
}
```
After:
```
var url: URL {

  switch self {
    case .callWithLimit(let path, let page, let limit):
    // create query items

    let pageQuery = URLQueryItem(name: "page", value: "\(page)")
    let limitQuery = URLQueryItem(name: "limit", value:"\(limit)")

    // add path to main url
    let url = mainDomain.appendingPathComponent(path.rawValue)

    var component = URLComponents(url: url, resolvingAgainstBaseURL: true)!
    component.queryItems = [pageQuery, limitQuery]
    return component.url!
}
```
A bit complicated, eh? but yet it’s simple and to the point, you create quires in first, add path to your main URL, then add quires via component builder, you can use the builder to build the whole URL from scratch too but that would be way longer lines indeed!


Lately I noticed that [Alamofire](https://github.com/Alamofire/Alamofire#crud--authorization) is doing almost the same way in their documentation so check it out in case you didn’t, very specific and would love to try it one day!


## Going Production:
> We’re going production tomorrow!

> Wait what? do we’ve a ready API link to connect to?

> Oh yes here you’re the link! Check your slack.


And suddenly you’re going to replace that link in all of your View controllers, data sources, etc! but hold on a second, can’t we do it in a better way?

This can be a nightmare  or a two clicks only, this is how I do it, and how you should too!

let’s say you’re working on google search app and you’re using the coming urls for development and production apis:
```
dev.google.com/api/          // for development url
google.com/api_mobile/       // for production one
```
First of all we need to setup Xcode to use different schemes for both production and development configurations, check this gif, very easy to follow:
<img height=600 src="https://media.giphy.com/media/3o7aDdz6lz7IJlOssE/giphy.gif">

You duplicate release configurations, then you create new scheme for your app, call it for clarity: YourAppNameDevelopment.

Easy, right? now let’s do the next step on detecting this configurations on our code.

How to detect this? it will be via our info.plist file, will add a new var to it and let’s call it “Config” and give it a value: $(CONFIGURATION).

<img height=600 src="https://media.giphy.com/media/3ohhwMuhXCDSlsvfna/giphy.gif">

Now we can read from info.plist what configuration is being used by our current build, now let’s make sure the build is using the development config too!

<img height=600 src="https://media.giphy.com/media/3ov9k49KEq7MLv6Eco/giphy.gif">

###### Now Xcode is all set, time to get code in action!

---
```
// will add new var to the enum called scheme

    var scheme: String {
        return Bundle.main.object(forInfoDictionaryKey: "Config") as! String
    }

// update the mainDomain url to check the configuration naming and return results accordingly

    var mainDomain: URL {
        switch scheme {
        case "Development":
            return URL(string: "dev.google.com/api/")!
        default:
            return URL(string: "google.com/api_mobile/")!
        }
    }
```

New variable will be added to our classic enum, and a little modification to our main url, and now we will never need to worry at all about being on production or development, it’s a two clicks away!

check the enhanced URLsFactory enum code on github, and let me know if you’ve suggestions or if you have any questions that might interest others about urls? or iOS development in general!

Share, comments, and stars is always welcome and appreciated! Thanks for reading so far, and Good luck with getting on Appstore!


##### Now you can write our links more conveniently or as we love to call it swiftly ;)

```
// normal api call url
﻿let url = URLsFactory.appSimple(.profileGame).url
// notice you don't need to write URL() in every call, a plus
// or with paging one
let urlWithPaging = URLsFactory.getWithPaging(.mainStream, page: 15, limit: 15).url
```

----
This long piece has been on medium as 3 parts: 

* Read first part here [Medium](https://medium.com/@yoloabdo/swifting-app-links-constants-869bcb5c5dba#.3xn7gnuip?source=github) 
* Read the 2nd here [Medium](https://medium.com/@yoloabdo/swifting-apis-2-0-20e53c9e0fd?source=github)
* Read the 3rd here [Medium](https://medium.com/@yoloabdo/lets-go-production-a5099ff18770?source=github) 

To get more about the power of Enums, I reccomend this article: 

[Advanced & Practical Enum usage in Swift](https://appventure.me/2015/10/17/advanced-practical-enum-examples/)

Don't forget to git the attached playground for the complete project!

Happy coding! 
