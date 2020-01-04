//
//  InvocationDemoTests.swift
//  InvocationDemoTests
//
//  Created by Jiang on 2020/1/4.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

import XCTest
@testable import InvocationDemo

class TestModel:Hashable{
    static func == (lhs: TestModel, rhs: TestModel) -> Bool {
        return lhs.name == rhs.name
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
    }
    var name:String = ""
}
class InvocationDemoTests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        self.invocation(#selector(performMethod(userInfo:)), args: [["":""]])
    }
    
    func testWrongArgumentTypePerform(){
//        在iOS13运行没问题，iOS13以下会崩溃，多下载几个不同版本的模拟器试一试就知道了。
        let value = self.invocation(#selector(unknownErrorPerformMethod(userInfo:)), userInfo: ["model":TestModel.init()])
        self.performSelector(inBackground: #selector(unknownErrorPerformMethod(userInfo:)), with: ["model":TestModel.init()])
//        直接调用不会有问题，10 - 13都没问题
//        let value = self.unknownErrorPerformMethod(userInfo: ["123":TestModel.init()])
        assert(value != nil)
    }
    func testReturnValueAutoRelease(){
        let value = self.releaseReturnValueInvocation(#selector(performMethod(userInfo:)), args: [["":""]])
        assert(value != nil)
    }
    
    @objc func performMethod(userInfo:[AnyHashable:Any])->NSObject{
        return NSObject.init()
    }
    
    @objc func unknownErrorPerformMethod(userInfo:[AnyHashable:AnyHashable])->NSObject{
        return NSObject.init()
    }


    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    

}
