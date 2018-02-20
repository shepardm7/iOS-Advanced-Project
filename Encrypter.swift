//
//  Encrypter.swift
//  Project
//
//  Created by Sateek Roy on 2017-07-20.
//  Copyright © 2017 SateekLambton. All rights reserved.
//

import Foundation

class Encrypter {
    
    private static func initialize() -> [String : String] {
        var dict: [String : String] = [:]
        
        //to encrypt A - Z or a - z
        var num: Int = 2
        for i in 65...90 {
            while(true){
                if isPrime(num){
                    break
                }
                num += 1
            }
            dict[String(UnicodeScalar(UInt8(i)))] = String(num)
            num += 1
        }
        
        //to encrypt 0 - 9
        var ascii: Int = 65
        for i in 1...9  {
            dict[String(i)] = String(UnicodeScalar(UInt8(ascii)))
            ascii += 2
        }
        
        dict[String(0)] = "S"
        
        //to encrypt " "
        dict[" "] = "#"
        
        return dict
    }
    
    private static func isPrime(_ num: Int) -> Bool {
        var flag = 0
        for i in stride(from: 2, through: (num/2), by: 1) {
            if (num % i == 0){
                flag = 1
                break
            }
        }
        
        if flag == 0 {
            return true
        }
        
        return false
    }
    
    private static var encryptDict : [String : String] = initialize()
    
    public static func encrypt(_ str: String) -> String {
        
        var encryptedStr = ""
        for i in 0..<str.characters.count {
            let index = str.characters.index(str.startIndex, offsetBy: i)
            if (encryptDict[String(str[index]).uppercased()] != nil) {
                if (i < str.characters.count - 1) {
                    encryptedStr = encryptedStr + encryptDict[String(str[index]).uppercased()]! + "/"
                }
                else {
                    encryptedStr = encryptedStr + encryptDict[String(str[index]).uppercased()]!
                }
            }
        }
        
        return encryptedStr
    }
    
    public static func decrypt(_ str: String) -> String {
        
        var decryptedStr = ""
        var char = ""
        for i in 0..<str.characters.count {
            let index = str.characters.index(str.startIndex, offsetBy: i)
            if (String(str[index]) != "/") {
                char = char + String(str[index])
                if(i == str.characters.count - 1){
                    for (key, val) in encryptDict {
                        if val == char {
                            decryptedStr = decryptedStr + key
                            break
                        }
                    }
                }
            }
            else if (String(str[index]) == "/" || i == str.characters.count - 1){
                for (key, val) in encryptDict {
                    if val == char {
                        decryptedStr = decryptedStr + key
                        break
                    }
                }
                char = ""
            }
        }
        
        return decryptedStr
    }
    
}
