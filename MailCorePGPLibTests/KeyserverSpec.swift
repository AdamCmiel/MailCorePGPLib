//
//  KeyserverSpec.swift
//  MailCorePGPLib
//
//  Created by Adam Cmiel on 5/9/16.
//  Copyright © 2016 Adam Cmiel. All rights reserved.
//

import Quick
import Nimble
@testable import MailCorePGPLib

class KeyserverApiSPec: QuickSpec {
    override func spec() {
        let goodQueryString = "adamcmiel@gmail.com"
        let badQueryString = "$%&^(*^*^$%*&%$"
        
        describe("forming URLs") {
            it("should form a url from a search query") {
                expect { try KeyserverAPI.searchURL(query: goodQueryString) }.toNot(throwError())
                
                do {
                    let url:NSURL = try KeyserverAPI.searchURL(query: goodQueryString)
                    let urlString = url.URLString
                    expect(urlString).to(contain("&search=\(goodQueryString)"))
                } catch KeyserverAPI.KeyserverAPIError.URL(let urlString) {
                    fail("failed with URL: \(urlString)")
                } catch let error {
                    print(error)
                    fail("unrecognized error")
                }
            }
            
            it("should fail with a bad url string") {
                expect { try KeyserverAPI.searchURL(query: badQueryString) }.to(throwError())
            }
        }
        
        describe("fetching key data") {
            it("should fetch the data with a good query") {
                var responseString: String? = nil
                
                KeyserverAPI.publicKeyForQuery(goodQueryString, successCallback: { response in
                    print(response)
                    responseString = response
                }, errorCallback: { error in
                    print(error)
                    fail()
                })
                
                expect(responseString).toEventuallyNot(beNil(), timeout: 10)
            }
            
            it("should error with a poor query") {
                var responseString: String? = nil
                
                KeyserverAPI.publicKeyForQuery(badQueryString, successCallback: { response in
                    print(response)
                    fail()
                }, errorCallback: { error in
                    responseString = "expected to fail"
                })
                
                expect(responseString).toEventuallyNot(beNil(), timeout: 10)
            }
        }
    }
}
