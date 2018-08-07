//
//  ViewController.swift
//  Swift OpenSSL AES加密
//
//  Created by HY on 2018/8/6.
//  Copyright © 2018年 XY. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        let aes = openssl.AES()
        
        print("AES明文 = wangming")
        let aes1 = aes.encrypt(string: "wangming")?.base64EncodedString() ?? "null"
        print("AES加密结果 = \(aes1)")
        let aes2 = aes.decrypt(base64String: aes1) ?? "null"
        print("AES解密结果 = \(aes2)")
        
        
        print("RSA公钥明文结果 = wangming")
        let rsa  =  openssl.RSA.publicEncrypt(str:"wangming")!
        print("RSA公钥加密结果 = \(rsa)")
        let rsa1 = openssl.RSA.privateDecrypt(str: rsa)!
        print("RSA私钥解密结果 = \(rsa1)")
    }
    
}


