//
//  Gender.swift
//  RxSwiftPractice
//
//  Created by Matsuoka Yoshiteru on 2018/06/06.
//  Copyright © 2018年 culumn. All rights reserved.
//

import Foundation

enum Gender {
    case male
    case female
    case other

    var text: String {
        switch self {
        case .male:
            return "male"
        case .female:
            return "female"
        case .other:
            return "other"
        }
    }

    static let all: [Gender] = [.male, .female, .other]
}
