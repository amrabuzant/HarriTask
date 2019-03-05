//
//  APIs.swift
//  HarriTask
//
//  Created by Amr Abu Zant on 3/5/19.
//  Copyright © 2019 Amr Abu Zant. All rights reserved.
//

import Foundation
import Alamofire

class APINames {
    static let SERVER = "http://api.harridev.com/api/"
    static let VERSION = "v1/"
    static let Login = SERVER + VERSION + "login"
    static let Logout = SERVER + VERSION + "mobile_logout"
    
}


class APIMethods {
    
    class func doLogin(credentials: LoginObj, completion: @escaping (_ data: UserObj?, _ error: String?) -> Void) {
        
        let parameters: [String: String] = ["username" : credentials.username, "password" : credentials.password]

        Alamofire.request(APINames.Login, method: .put ,parameters:parameters, encoding: JSONEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success:
                do {
                    let jsonDecoder = JSONDecoder()
                    let responseModel = try jsonDecoder.decode(APIResponse.self, from: response.data!)
                    if (responseModel.status_code == 200){
                        saveCookies(response: response)
                       let resp = try jsonDecoder.decode(UserObj.self, from: response.data!)
                        completion(resp,nil)
                    }else{
                        completion(nil,responseModel.status)
                    }
                    
                } catch let error as NSError {
                    completion(nil, error.description)
                }
            case .failure(let error):
                completion(nil,error.localizedDescription)
            }
            
        }
        
    }
    
    static func doLogout(completion: @escaping (_ data: Bool?, _ error: String?) -> Void) {
     
        loadCookies()
        Alamofire.request(APINames.Logout).validate().responseJSON { response in
            switch response.result {
            case .success:
                do {
                    let jsonDecoder = JSONDecoder()
                    let responseModel = try jsonDecoder.decode(APIResponse.self, from: response.data!)
                    if (responseModel.status_code == 200){
                        completion(true,nil)
                    }else{
                        completion(nil,responseModel.status)
                    }
                    
                } catch let error as NSError {
                    completion(nil, error.description)
                }
            case .failure(let error):
                completion(nil,error.localizedDescription)
            }
            
        }
    }
    
    static func saveCookies(response: DataResponse<Any>) {
        let headerFields = response.response?.allHeaderFields as! [String: String]
        let url = response.response?.url
        let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url!)
        var cookieArray = [[HTTPCookiePropertyKey: Any]]()
        for cookie in cookies {
            cookieArray.append(cookie.properties!)
        }
        UserDefaults.standard.set(cookieArray, forKey: "savedCookies")
    }
    
    static func loadCookies() {
        guard let cookieArray = UserDefaults.standard.array(forKey: "savedCookies") as? [[HTTPCookiePropertyKey: Any]] else { return }
        for cookieProperties in cookieArray {
            if let cookie = HTTPCookie(properties: cookieProperties) {
                HTTPCookieStorage.shared.setCookie(cookie)
            }
        }
    }
    
}
