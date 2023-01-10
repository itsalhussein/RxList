//
//  Task.swift
//  RxList
//
//  Created by Hussein Anwar on 10/01/2023.
//

import Foundation
import UIKit

enum Priority: Int {
    case high
    case medium
    case low
}

struct Task {
    let title: String
    let priority: Priority
}
