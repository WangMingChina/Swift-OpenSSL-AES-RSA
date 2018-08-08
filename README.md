# Swift-OpenSSL-AES-RSA
ios swift OpenSSL AES RSA 加密解密
*  swift使用OpenSSL的AES和RSA加密解密
```
        let key = "DQN2EhvbyHKjngommtB35wIrU0cIeKFmYIkHKN37ZOCQA9KHmebSjYA7n3Fkx+Uf9cgyjWbxIYYFPovVYuD5/GEKW1Gc3++hREOAlkD9lbYLfPWahZUJ9oLzgDV0Bzgdj6c0FjYzNyMF5JNFTqkhrM4IRgNtg84Hv+gGMWVr0Kc="
        
        let iv = "Ww7g/NpaBqT669mE/UPhWR17qwdt1vvOWkNdpl1wIsQo8wisP22FpBZw6bA/Re8wqLGDXfx4iotdFEisFH0do5xqUvNoZEbbj3M2lTrlI/RB1YScJI5xanBE9bbNXqNcqFIX5klnBxcNPB+O+pu7oVSuJtbhxclOj3dM+JQO2KY="
        
        
        let data = "sLcwkm+xB10ArKowmJprx3VwphMc75IIK6PcL3+SMr1BCROf+3fOt2bfaTe08nDU"
        
        
        let key1 = openssl.RSA.publicDecrypt(str: key)!
        let iv1  = openssl.RSA.publicDecrypt(str: iv)!
        let aes  = try! openssl.AES(key: key1, iv: iv1)
        
        let result = aes.decrypt(base64String: data)!
```
        
