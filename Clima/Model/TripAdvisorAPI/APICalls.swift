//
//  APICalls.swift
//  Clima
//
//  Created by Krishna Venkatramani on 5/15/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation


class TripAdvisorAPI {
    
    var headers:[String:String]?;
    var urlString:String?;
    
    init(_ headers:[String:String], _ urlString:String){
        self.headers = headers;
        self.urlString = urlString;
    }
    
    
    func getData(completion : @escaping (Data?,URLResponse?,Error?) -> ()){
        print("TripAdvisor API CALL")
        guard let safeUrlString = self.urlString , let safeHeaders = self.headers ,let safeUrl = URL(string: safeUrlString ?? "") else { return }
        var request = URLRequest(url: safeUrl);
        request.allHTTPHeaderFields = safeHeaders;
        request.httpMethod = "GET";
        URLSession.shared.dataTask(with: request, completionHandler: completion).resume();
    }
}
