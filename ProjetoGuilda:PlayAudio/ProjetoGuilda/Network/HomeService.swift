//
//  ApiManager.swift
//  ProjetoGuilda
//
//  Created by Pedro Menezes on 27/10/20.
//

import Foundation
import Alamofire

protocol HomeProviderDelegate {
    func getInfos(successCallBack: @escaping (SongsDto) -> Void, errorCallBack: @escaping (Error) -> Void)
}

class HomeProvider: HomeProviderDelegate {
    func getInfos(successCallBack: @escaping (SongsDto) -> Void, errorCallBack: @escaping (Error) -> Void) {
        
        let httpHeader = HTTPHeader(name: "Content-Type", value: "application/json")
        let httpHeaders = HTTPHeaders([httpHeader])
        
        var url = ""
        #if DEBUG
            url = "https://0409321c-b7f9-4dbf-9f5a-3375a442aaba.mock.pstmn.io/songs"
        #elseif HOMOLOG
            url = "https://0409321c-b7f9-4dbf-9f5a-3375a442aaba.mock.pstmn.io/songs"
        #elseif PROD
            url = "https://0409321c-b7f9-4dbf-9f5a-3375a442aaba.mock.pstmn.io/songs"
        #endif
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: httpHeaders)
            .responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let data):
                    if let data_ = data as? [String: Any],
                       let jsonData = try? JSONSerialization.data(withJSONObject: data_),
                       let model = try? JSONDecoder().decode(SongsDto.self, from: jsonData) {
                        successCallBack(model)
                    } else {
                        errorCallBack(ServiceError.parsing)
                    }
                case .failure(let error):
                    print(error)
                    errorCallBack(ServiceError.failure)
                }
            })
    }
}
