//
//  FutureKitTests.swift
//  FutureKitTests
//
//  Created by Michael Gray on 4/12/15.
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import FutureKit
import XCTest

extension XCTestCase {
    
    func expectationTestForFutureCompletion<T>(_ description : String, future f: Future<T>,
        file: StaticString = #file,
        line: UInt = #line,
        assertion : ((value : FutureResult<T>) -> (assert:Boolean,message:String))
        ) -> XCTestExpectation! {
            
            let e = self.expectation(withDescription: description)
            
            f.onComplete { (value) -> Void in
                let test = assertion(value:value)
                
                XCTAssert(test.assert,test.message,file:file,line:line)
                e.fulfill()
            }
            return e
    }
    
    func expectationTestForFutureSuccess<T>(_ description : String,future f: Future<T>,
        file: StaticString = #file,
        line: UInt = #line,
        test : ((result:T) -> Boolean)
        ) -> XCTestExpectation! {
        
            return self.expectationTestForFutureCompletion(description,future: f, file:file,line:line)  { (value : FutureResult<T>) -> (assert: Boolean, message: String) in
                switch value {
                case let .success(result):
                    return (test(result: result),"test result failure for Future with result \(result)" )
                case let .fail(e):
                    return (false,"Future Failed with \(e)" )
                case .cancelled:
                    return (false,"Future Cancelled" )
                }
            }
    }
    
    func expectationTestForFutureSuccess<T>(_ description : String, future f: Future<T>,
        file: StaticString = #file,
        line: UInt = #line
        ) -> XCTestExpectation! {
            
            return self.expectationTestForFutureSuccess(description, future: f, test: { (result) -> Boolean in
                return true
            })
            
    }
}
