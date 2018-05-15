//
//  Booking.swift
//  iCab
//
//  Created by Jaksa Tomovic on 15/05/2018.
//  Copyright © 2018 Jakša Tomović. All rights reserved.
//

import UIKit
import CoreData

extension Booking: Encodable {
    
//    @NSManaged public var distance: Double
//    @NSManaged public var duration: Int16
//    @NSManaged public var status: String?
//    @NSManaged public var time: Date?
//    @NSManaged public var locations: NSOrderedSet?
    @NSManaged public var uuid: String
    
    private enum CodingKeys: String, CodingKey { case status, distance, duration, time, uuid }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(status, forKey: .status)
        try container.encode(distance, forKey: .distance)
        try container.encode(duration, forKey: .duration)
        try container.encode(time, forKey: .time)
        try container.encode(uuid, forKey: .uuid)
    }
}
