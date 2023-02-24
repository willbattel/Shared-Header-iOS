//
//  Data.swift
//  Shared Header
//
//  Created by Will Battel on 2/24/23.
//

import UIKit

struct Widget: Hashable {
    let id: String
    let color: UIColor
}

struct Cat: Hashable {
    let id: String
    let color: UIColor
}

struct Dog: Hashable {
    let id: String
    let color: UIColor
}

class Data {
    
    static let widgets: [Widget] = [
        Widget(id: "widget0", color: .systemRed),
        Widget(id: "widget1", color: .systemOrange),
        Widget(id: "widget2", color: .systemYellow),
        Widget(id: "widget3", color: .systemGreen),
        Widget(id: "widget4", color: .systemBlue),
        Widget(id: "widget5", color: .systemIndigo),
        Widget(id: "widget6", color: .systemPurple),
        Widget(id: "widget7", color: .systemRed),
        Widget(id: "widget8", color: .systemOrange),
        Widget(id: "widget9", color: .systemYellow),
        Widget(id: "widget10", color: .systemGreen),
        Widget(id: "widget11", color: .systemBlue),
        Widget(id: "widget12", color: .systemIndigo),
        Widget(id: "widget13", color: .systemPurple),
    ]
    
    static let cats: [Cat] = [
        Cat(id: "cat0", color: .systemRed),
        Cat(id: "cat1", color: .systemOrange),
        Cat(id: "cat2", color: .systemYellow),
        Cat(id: "cat3", color: .systemGreen),
        Cat(id: "cat4", color: .systemBlue),
        Cat(id: "cat5", color: .systemIndigo),
        Cat(id: "cat6", color: .systemPurple),
        Cat(id: "cat7", color: .systemRed),
        Cat(id: "cat8", color: .systemOrange),
        Cat(id: "cat9", color: .systemYellow),
        Cat(id: "cat10", color: .systemGreen),
        Cat(id: "cat11", color: .systemBlue),
        Cat(id: "cat12", color: .systemIndigo),
        Cat(id: "cat13", color: .systemPurple),
    ]
    
    static let dogs: [Dog] = [
        Dog(id: "dog0", color: .systemRed),
        Dog(id: "dog1", color: .systemOrange),
        Dog(id: "dog2", color: .systemYellow),
        Dog(id: "dog3", color: .systemGreen),
        Dog(id: "dog4", color: .systemBlue),
        Dog(id: "dog5", color: .systemIndigo),
        Dog(id: "dog6", color: .systemPurple),
        Dog(id: "dog7", color: .systemRed),
        Dog(id: "dog8", color: .systemOrange),
        Dog(id: "dog9", color: .systemYellow),
        Dog(id: "dog10", color: .systemGreen),
        Dog(id: "dog11", color: .systemBlue),
        Dog(id: "dog12", color: .systemIndigo),
        Dog(id: "dog13", color: .systemPurple),
    ]
    
}
