//
//  UserObj.swift
//  HarriTask
//
//  Created by Amr Abu Zant on 3/5/19.
//  Copyright © 2019 Amr Abu Zant. All rights reserved.
//

import Foundation

struct User: Codable {
    let id: Int
    let email: String
}

struct UserObj: Codable {
    let status: String
    let status_code: Int
    let data: User
}
