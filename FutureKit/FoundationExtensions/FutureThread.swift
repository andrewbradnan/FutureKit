//
//  FKThread.swift
//  FutureKit
//
//  Created by Michael Gray on 6/19/15.
//  Copyright (c) 2015 Michael Gray. All rights reserved.
//

import Foundation

public class FutureThread {
    
    public typealias __Type = Any
    
    var block: () -> Completion<__Type>
    
    private var promise = Promise<__Type>()
    
    public var future: Future<__Type> {
        return promise.future
    }
    
    private var thread : Thread!
    
    public init(block b: @escaping () -> __Type) {
        self.block = { () -> Completion<__Type> in
            return .success(b())
        }
        self.thread = Thread(target: self, selector: #selector(FutureThread.thread_func), object: nil)
    }
    public init(block b: @escaping () -> Completion<__Type>) {
        self.block = b
        self.thread = Thread(target: self, selector: #selector(FutureThread.thread_func), object: nil)
    }
    
    public init(block b: @escaping () -> Future<__Type>) {
        self.block = { () -> Completion<__Type> in
            return .completeUsing(b())
        }
        self.thread = Thread(target: self, selector: #selector(FutureThread.thread_func), object: nil)
    }
    
    @objc public func thread_func() {
        self.promise.complete(self.block())
    }
    
    public func start() {
        self.thread.start()
    }
   
}
