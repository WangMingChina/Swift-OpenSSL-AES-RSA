//
//  opensslAES.swift
//  Swift OpenSSL AES加密
//
//  Created by HY on 2018/8/7.
//  Copyright © 2018年 XY. All rights reserved.
//

import Foundation

struct openssl {
    
    struct AES {
        let key:String
        let iv:String
        init(key:String,iv:String) throws {
            self.key = key
            self.iv  = iv
            switch key.count * 8 {
            case 128,256,192:
                break
            default:
                throw NSError(domain: "key位数出错", code: -1, userInfo: nil)
            }
        }
        ///自定生成密码和偏移量
        init() {
            var key = ""
            var iv = ""
            for i in 0..<32 {
                let number = arc4random() % 36
                if number < 10 {
                    let figure = Int(arc4random() % 10)
                    key.append("\(figure)")
                }else{
                    let bool = number % 2 == 0
                    let figure = arc4random() % 26 + (bool ? 65 : 97)
                    let c = Character.init(Unicode.Scalar.init(figure)!)
                    key.append(c)
                }
                if i < 16 {
                    let figure = Int(arc4random() % 10)
                    iv.append("\(figure)")
                }
            }
            self.key = key
            self.iv  = iv
        }
        func encrypt(data:Data?) -> Data?{
            guard let data = data else {
                return nil
            }
            guard var c_iv   = (iv.data(using: String.Encoding.utf8)?.map{$0}) else {
                return nil
            }
            guard var c_key   = (key.data(using: String.Encoding.utf8)?.map{$0}) else {
                return nil
            }
            var c_data = data.map{UInt8($0)}
            var lengh = 0
            let int_AES_BLOCK_SIZE = Int(AES_BLOCK_SIZE)
            if c_data.count % 16 == 0 {
                lengh = c_data.count + int_AES_BLOCK_SIZE
            }else{
                lengh = (c_data.count / int_AES_BLOCK_SIZE + 1) * int_AES_BLOCK_SIZE
            }
            for _ in 0..<(16 - data.count % 16) {
                c_data.append((UInt8(16 - data.count % 16)))
            }
            var c_out  = Array<UInt8>.init(repeating: 0, count: lengh)
            var aesKey = AES_KEY()
            AES_set_encrypt_key(&c_key, Int32(key.count * 8), &aesKey)
            AES_cbc_encrypt(&c_data, &c_out, lengh, &aesKey, &c_iv, AES_ENCRYPT)
            return Data.init(bytes: c_out)
        }
        
        func encrypt(string:String?) -> Data? {
            guard let dataString = string?.data(using: String.Encoding.utf8)  else {
                return nil
            }
            return encrypt(data: dataString)
        }
        
        
        func decrypt(data:Data?)->Data?{
            guard let data = data else {
                return nil
            }
            guard var c_iv   = (iv.data(using: String.Encoding.utf8)?.map{$0}) else {
                return nil
            }
            guard var c_key   = (key.data(using: String.Encoding.utf8)?.map{$0}) else {
                return nil
            }
            var c_data = data.map{UInt8($0)}
            var lengh = 0
            let int_AES_BLOCK_SIZE = Int(AES_BLOCK_SIZE)
            if c_data.count % 16 == 0 {
                lengh = c_data.count
            }else{
                lengh = (c_data.count / int_AES_BLOCK_SIZE + 1) * int_AES_BLOCK_SIZE
            }
            var c_out = Array<UInt8>.init(repeating: 0, count: lengh)
            var aesKey = AES_KEY()
            AES_set_decrypt_key(&c_key, Int32(key.count * 8), &aesKey)
            AES_cbc_encrypt(&c_data, &c_out, lengh, &aesKey, &c_iv, AES_DECRYPT)
            let fillCount = Int(c_out[c_out.count - 1])
            c_out = Array(c_out[0..<(c_out.count - fillCount)])
            let resut = Data.init(bytes: c_out)
            return resut
        }
        func decrypt(base64String:String?)->String? {
            guard let base64String = base64String else {
                return nil
            }
            guard let data = Data.init(base64Encoded: base64String) else {
                return nil
            }
            guard let result = decrypt(data: data) else {
                return nil
            }
            return String.init(data: result, encoding: String.Encoding.utf8)
        }
    }
    
    
    struct RSA {
        ///公钥路径
       static let rsa_public_key  = Bundle.main.path(forResource: "rsa_public_key.pem", ofType: nil, inDirectory: nil)
        ///私钥路径
       static let rsa_private_key = Bundle.main.path(forResource: "rsa_private_key.pem", ofType: nil, inDirectory: nil)
        ///公钥加密
       static func publicEncrypt(str:String)->String?{
            guard var c_data = (str.data(using: String.Encoding.utf8)?.map{$0}) else {
                return nil
            }
            let path_key = rsa_public_key
        
            let count = c_data.count
            guard let file = fopen(path_key, "r") else {
                print("open key file error")
                return nil
            }

            guard let p_rsa = PEM_read_RSA_PUBKEY(file, nil, nil, nil) else {
                ERR_print_errors_fp(file)
                print("读取秘钥失败")
                return nil
            }
            let rsa_len = Int(RSA_size(p_rsa))
            var p_en = Array<UInt8>.init(repeating: 0, count: rsa_len)
            let lent = RSA_public_encrypt(Int32(count), &c_data, &p_en, p_rsa, RSA_SSLV23_PADDING)
            if lent < 0 {
                print("加密失败")
                return nil
            }
            let result = Data(bytes: p_en)
            fclose(file)
            return result.base64EncodedString()
        }
       
        ///公钥解密
       static func publicDecrypt(str:String)->String?{
            guard let data = Data.init(base64Encoded: str) else {
                return nil
            }
            let path_key = rsa_public_key
            var c_data = data.map{$0}
            guard let file = fopen(path_key, "r") else {
                print("open key file error")
                return nil
            }
        
            guard let p_rsa = PEM_read_RSA_PUBKEY(file, nil, nil, nil) else {
                ERR_print_errors_fp(file)
                print("读取秘钥失败")
                return nil
            }
    
            let rsa_len = Int(RSA_size(p_rsa))
            var p_en = Array<UInt8>.init(repeating: 0, count: rsa_len)
            
            let lent = RSA_public_decrypt(Int32(rsa_len), &c_data, &p_en, p_rsa, RSA_PKCS1_PADDING)
            if lent < 0 {
                print("解密失败")
                return nil
            }
            let result = Data(bytes: p_en.filter{ $0 > 0})
            fclose(file)
            return String.init(data: result, encoding: String.Encoding.utf8)
        }
        ///私钥加密
        ///static func privateEncrypt(str:String)->String?
        ///私钥解密
        static func privateDecrypt(str:String)->String?{
            guard let data = Data.init(base64Encoded: str) else {
                return nil
            }
            let path_key = rsa_private_key
            var c_data = data.map{$0}
            
            guard let file = fopen(path_key, "r") else {
                print("open key file error")
                return nil
            }
            guard let p_rsa = PEM_read_RSAPrivateKey(file, nil, nil, nil) else {
                ERR_print_errors_fp(file)
                print("读取秘钥失败")
                return nil
            }
            let rsa_len = Int(RSA_size(p_rsa))
            print("rsa_len = \(rsa_len)")
            var p_en = Array<UInt8>.init(repeating: 0, count: rsa_len)
            let lent = RSA_private_decrypt(Int32(rsa_len), &c_data, &p_en, p_rsa, RSA_PKCS1_PADDING)
            if lent < 0 {
                print("解密失败")
                return nil
            }
            let result = Data(bytes: p_en.filter{ $0 > 0})
            fclose(file)
            return String.init(data: result, encoding: String.Encoding.utf8)
        }
    }
}

