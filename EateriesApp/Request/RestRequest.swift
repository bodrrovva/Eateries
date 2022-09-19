//
//  RestRequest.swift
//  Eateries
//
//  Created by admin on 15.09.2022.
//

//import Foundation
//import Alamofire
//import SwiftyJSON
//
//class RestRequest: ObservableObject  {
//
//    @Published var restArray: [RestModel] = []
//
//    func getRest(){
//        let url = "http://127.0.0.1:5000"
//
//        AF.request(url, method: .get).validate().responseJSON { response in
//            switch response.result {
//            case.success(let value):
//                let json = JSON(value)
//                for i in 0..<json.count{
//                    print(json[i][4])
//                    self.restArray.append(
//                        RestModel(
//                            id: json[i][0].intValue,
//                            favotite: json[i][1].boolValue,
//                            image: json[i][2].stringValue,
//                            location: json[i][3].stringValue,
//                            name: json[i][4].stringValue,
//                            type: json[i][5].stringValue
//                        ))
//                }
//            case.failure(let error):
//                print(error)
//            }
//            print("1")
//            print(self.restArray)
//        }
//    }
//}
