//
//  EYunViewController.swift
//  SHMoyaNetwork
//
//  Created by YYKJ on 2021/10/12.
//

import UIKit
import SwiftyJSON

class EYunViewController: UIViewController {

    @IBOutlet weak var codeImageView: UIImageView!
    @IBOutlet weak var accountTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var verifiedTf: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(codeImageTapClick))
        codeImageView.isUserInteractionEnabled = true
        codeImageView.addGestureRecognizer(tapGesture)
        
        fetchGraphicCode()
    }
    
    @objc func codeImageTapClick() {
        fetchGraphicCode()
    }
    
    func fetchGraphicCode() {
        eyunProvider.request(.graphicCode(uuid)) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data

                guard let jsonData = try? JSON(data: data),
                      let imageDataString = jsonData["data"].string,
                      let imageData = Data(base64Encoded: imageDataString, options: .ignoreUnknownCharacters)
                else { return }
                
                let image = UIImage(data: imageData)
                self.codeImageView.image = image
                
            case let .failure(error):
                // TODO: handle the error
                print(error)
            }
        }
    }
    
    @IBAction func loginButtonClick(_ sender: Any) {
        guard let account = accountTf.text,
              let password = passwordTf.text,
              let code = verifiedTf.text,
              !account.isEmpty,
              !password.isEmpty,
              !code.isEmpty
        else {
                  print("有必填项为空")
                  return
              }
        
        eyunProvider.request(.login(account, password, code)) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let statusCode = moyaResponse.statusCode
                if statusCode == 200 {
                    print("登录成功")
                    
                    guard let jsonData = try? JSON(data: data),
                          let access = jsonData["data"]["access"].string
                    else { return }
                    
                    source.token = access
                }
                
            case let .failure(moyaError):
                print(moyaError.errorDescription ?? "未知错误")
            }
        }
    }
    
    
    @IBAction func getUserInfoClick(_ sender: Any) {
        eyunProvider.request(.userInfo("")) { result in
            switch result {
            case let .success(moyaResponse):
                print(try! moyaResponse.mapJSON())
            case let .failure(moyaError):
                print(moyaError.errorDescription ?? "未知错误")
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        
    }
    

}
