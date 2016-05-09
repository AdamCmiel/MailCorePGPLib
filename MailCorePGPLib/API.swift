//
//  API.swift
//  MailCorePGPLib
//
//  Created by Adam Cmiel on 5/9/16.
//  Copyright © 2016 Adam Cmiel. All rights reserved.
//

import Foundation
import Alamofire

struct KeyserverAPI {
    static let baseURI = "https://pgp.mit.edu"
    static let getSearchPartial = "/pks/lookup?op=get&search="
    
    static func searchURL(query query: String) throws -> NSURL {
        let urlString = baseURI + getSearchPartial + query
        let url = NSURL(string: urlString)
        
        if let url = url {
            return url
        } else {
            throw KeyserverAPIError.URL(urlString: urlString)
        }
    }

    enum KeyserverAPIError: ErrorType {
        case URL(urlString: String)
        case Response(resopnseError: ErrorType)
        case NoContent
    }
    
    static func publicKeyForQuery(query: String, successCallback: (String -> Void), errorCallback: (ErrorType -> Void)) {
        do {
            let url = try searchURL(query: query)
            Alamofire.request(.GET, url).validate().response { request, response, data, error in
                
                if let error = error {
                    return errorCallback(KeyserverAPIError.Response(resopnseError: error))
                }
                
                let data = data!
                if let responseString = String(data: data, encoding: NSUTF8StringEncoding) {
                    return successCallback(responseString)
                } else {
                    return errorCallback(KeyserverAPIError.NoContent)
                }
            }
        } catch let error {
            errorCallback(error)
        }
    }
}

