//
//  Weather.swift
//  TestApp
//
//  Created by Andrzej Mistetskij on 7/14/16.
//  Copyright © 2016 Swift Devils. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

public typealias Success = (item: Any) -> Void
public typealias Failure = (error: String?) -> Void

public struct Weather: Mappable {
    public var city: String?
    public var temperature: Int?
    
    public init?(_ map: Map) {}
    
    public mutating func mapping(map: Map) {
        city <- map["name"]
        temperature <- map["main.temp"]
    }
    
    public static func getForecast(queryParameters: [String: AnyObject], completion: Success, failure: Failure) {
        let url = "http://api.openweathermap.org/data/2.5/weather"
        
        var parameters: [String: AnyObject] = ["APPID": "7d261ea6e556c0f4f08906ae8353f2bd",
                          "units" : "metric",
                          ]
        parameters += queryParameters
        
        Alamofire.request(.GET, url, parameters: parameters).validate().responseObject { (response: Response<Weather, NSError>) in
            switch response.result {
            case .Success:
                if let weather = response.result.value {
                    completion(item: weather)
                }
            case .Failure:
                failure(error: response.result.error?.localizedDescription)
            }
        }
    }
}