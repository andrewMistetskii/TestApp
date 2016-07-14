//
//  ExecutableQueue.swift
//  TestApp
//
//  Created by Andrzej Mistetskij on 7/13/16.
//  Copyright © 2016 Swift Devils. All rights reserved.
//

import Foundation

public protocol ExecutableQueue {
    // MARK: - Properties
    
    var queue: dispatch_queue_t { get }
}

extension ExecutableQueue {
    func execute(closure: () -> Void) {
        dispatch_async(queue, closure)
    }
}

public enum Queue: ExecutableQueue {
    case main
    case userInteractive
    case userInitiated
    case utility
    case background
    
    public var queue: dispatch_queue_t {
        switch self {
        case .main:
            return dispatch_get_main_queue()
        case .userInteractive:
            return dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)
        case .userInitiated:
            return dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
        case .utility:
            return dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)
        case .background:
            return dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
        }
    }
}