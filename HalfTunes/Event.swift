//
//  Event.swift
//  CTV App
//
//  Created by Local Administrator on 7/30/18.
//  Copyright © 2018 Ken Toh. All rights reserved.
//

import Foundation

class Event
{
    var startDate: Date
    var endDate: Date
    var title: String
    var image: NSURL
    var liveStream: String
    
    init(title: String, startDate: Date, endDate: Date,  liveStream: String, image: NSURL)
    {
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.liveStream = liveStream
        self.image = image
    }
}//end of class event
