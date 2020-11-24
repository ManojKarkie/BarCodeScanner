//
//  ConfigLoader.swift
//
//  Created by Manoj Karki on 4/27/20.
//

import Foundation

enum Environment {

  private static let infoDictionary: [String: Any] = {
    guard let dict = Bundle.main.infoDictionary else {
      fatalError("Plist file not found")
    }
    return dict
  }()

  static let rootURL: URL = {
    guard let url = URL(string: "https://app.imemotors.com.np:7778/api/") else {
      fatalError("BACKEND URL is invalid")
    }
    return url
  }()

}



struct ServerUrl {

    static var baseUrl: URL {
        return  Environment.rootURL
    }
    
    static var termsAndConditionUrl: String {
        let baseEP = baseUrl.absoluteString.replacingOccurrences(of: "/api/", with: "")
        return  baseEP + "/tac"
    }
    
    static var aboutUsUrl: String {
        return "http://www.imemotors.com.np/about-us/"
    }

    static var faqsUrl: String {
        let baseEP = baseUrl.absoluteString.replacingOccurrences(of: "/api/", with: "")
        return  baseEP + "/faq"
    }
}
