//
//  GHFlutterProtocol.swift
//  NativeProject
//
//  Created by apple on 2020/12/1.
//

import Flutter

protocol GHFlutterProtocol {
    
    /// 接收flutter发起的交互方法
    /// - Parameters:
    ///   - method: 方法名
    ///   - arguments: 参数
    ///   - result: 回调
    func receive(_ method: String, arguments: Any?, result: @escaping (Any) -> Void)
    
    /// 缓存FlutterMethodChannel的对象
    /// - Parameter channel: FlutterMethodChannel
    func cacheChannel(channel: FlutterMethodChannel)
    
    /// 生成flutter回调的指定格式
    /// - Parameters:
    ///   - success: 成功/失败
    ///   - response: 回调参数
    func formatFlutterResult(_ success: Bool, response: Any?, message: String?) -> String?
    
    /// 参数转字典的方法
    /// - Parameter arguments: 参数
    func dictionary(from arguments: Any?) -> [String : Any?]?
    
    /// 字典转json方法
    /// - Parameter dictionary: dictionary
    func jsonString(from dictionary: [String : Any]) -> String?
}

extension GHFlutterProtocol {
    
    func dictionary(from arguments: Any?) -> [String : Any?]? {
        guard let arguments: String = arguments as? String else {
            return nil
        }
        guard let data = arguments.data(using: .utf8) else {
            return nil
        }
        guard let object = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)  else {
            return nil
        }
        return object as? [String : Any?]
    }
    
    func jsonString(from dictionary: [String : Any]) -> String? {
        // 转string
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted) else {
            return nil
        }
        let json = String.init(data: data, encoding: .utf8)
        return json
    }
    
    func receive(_ method: String, arguments: Any?, result: @escaping (Any) -> Void) {}
    
    func cacheChannel(channel: FlutterMethodChannel) {}
    
    func formatFlutterResult(_ success: Bool, response: Any?, message: String?) -> String? {
        // 统一格式
        var dic: [String : Any] = [:]
        dic["success"] = success
        if let response: [String : Any] = response as? [String : Any] {
            dic["response"] = response
        }
        if let message = message {
            dic["message"] = message
        }
        return jsonString(from: dic)
    }
}
