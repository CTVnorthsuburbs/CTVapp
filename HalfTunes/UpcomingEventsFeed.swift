//
//  UpcomingEventsFeed.swift
//  CTV App
//
//  Created by William Ogura on 2/23/17.
//
//Upcoming Live Events Section
//
//Updated by Charlie Rooney
//Note:The first video in the link is really old,("title":"Boys Basketball Irondale vs. Elk River"), so I jumped over that video in the get UpcomingEventVideos Function. Copy and Paste the link into a browser, and you will see what I meanabout the first video being really old. All the other stuff seems to work.

//  Updated by Charlie Rooney July 27th 2018
//

import Foundation
import UIKit

//The three Structs used in the UpcomingEventsFeed class

public struct EventFeed: Decodable
{
    public let events: NSDictionary?
    public init?(json: JSON)
    {
        let events: NSDictionary? = "value" <~~ json
        self.events = events
    }
}//EventFeed

public struct EventResults: Decodable
{
    public let items: [Events]?
    public init?(json: JSON) {items = "items" <~~ json}
}//EventResults

public struct Events: Decodable
{
    public let title: String?
    public let link: String?
    public let description: String?
    public let image: String?
    public init?(json: JSON)
    {
        title = "title" <~~ json
        link = "link" <~~ json
        description = "description" <~~ json
        image = "Event_Photo" <~~ json
    }
}//Events

class UpcomingEventsFeed
{
    let upcomingEventFeedURL = URL(string: "http://www.ctv15.org/index.php?option=com_obrss&task=feed&id=2:app-json-feed&format=json")
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    /// Creates the NSURL session necessary to download content from remote URL.
    
    fileprivate func getNSURLSession() -> URLSession
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        return defaultSession
    }
    
    //This Function is called from the class CategoryTableViewController and HorizontalTableViewController
    func getUpcomingEventVideos(events: [Event]) -> [Video]
    {
        var videos = [Video]()
        var count = 0
        for event in events
        {
            let video = Video(title: event.title, thumbnail: nil, fileName: 0, sourceUrl: event.liveStream, comments: "", eventDate: event.startDate, thumbnailUrl: event.image, id: 1, isEvent: true, endDate: event.endDate)
            video?.setEndDate(date: event.endDate)
            
            if (count==0){count=1}    //Was showing a video from like 2014 first so had to jump over the first video
            else{videos.append(video!)} //Starting with the second video it adds it to the list
        }
        return videos
    }
    
    //This Function is called from the class CategoryTableViewController and HorizontalTableViewController
    func getUpcomingEventUpdate(category: Category) -> [Event]?
    {
        let section = checkForUpcomingSection(category: category)
        if(section != nil)
        {
            let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
            let semaphore = DispatchSemaphore(value: 0)
            var dataTask: URLSessionDataTask
            var events = [Event]()
            dataTask = defaultSession.dataTask(with: upcomingEventFeedURL!,  completionHandler:
                {
                    data, response, error in
                    DispatchQueue.main.async {UIApplication.shared.isNetworkActivityIndicatorVisible = true}
                    if let error = error {print(error.localizedDescription)}
                    else if let httpResponse = response as? HTTPURLResponse
                    {
                        if httpResponse.statusCode == 200
                        {
                            if(data != nil) {events = self.updateSearchResults(data)!}
                        }
                        else {print("!!!!!!!!!!!!!!!!!!!")}
                    }
                    semaphore.signal()
            })
            dataTask.resume()
            let _ = semaphore.wait(timeout: .distantFuture)
            DispatchQueue.main.async(execute: {UIApplication.shared.isNetworkActivityIndicatorVisible = false})
            return events
        }
        else {return [Event]()}
    }
    
    //Following functions are supporting the checkForUpcomingSection function and its supporting functions
    
    //Function called by the function getUpcomingEventUpdate
    func checkForUpcomingSection(category: Category) -> Section?
    {
        for section in category.sections
        {
            if(section.sectionType == SectionType.upcomingEventList){return section}
        }
        return nil
    }
    
    //Function called by the function getUpcomingEventUpdate
    fileprivate func updateSearchResults(_ data: Data?)-> [Event]?
    {
        var eventResults = [Event]()
        var results = [Events]()
        var json: [String: AnyObject]!
        
        do {json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as? [String: AnyObject]}
        catch {print(error)}
        
        if (json == nil) {return nil}
        guard let result = EventFeed(json: json) else {return nil}
        guard let events = EventResults(json: result.events as! JSON) else {return nil}
        
        if(events.items != nil) {for item in events.items! {results.append(item)}}
        
        for result in results
        {
            let eventResult =  parseResults(event: result)
            if(eventResult != nil) {eventResults.append(eventResult!)}
        }
        return eventResults
    }

    //This Function called by updateSearchResults
    func parseResults(event: Events) -> Event?
    {
        var eventResult: Event?
        
        let description: String = event.description!
        let separatedDescription = filterString(string: description).components(separatedBy: [" "])
        let startDate = formatDate(date: separatedDescription[1])
        let endDate = formatDate(date: separatedDescription[3])
        let location = getLocation(stringArray: separatedDescription)
        let liveStream = getLiveStreamAddress(stringArray: separatedDescription)
        let escapedString = event.image?.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        let url = NSURL(string: escapedString! )
        if(event.title != nil && event.image != nil && event.link != nil && location != nil && liveStream != nil )
        {
            eventResult = Event(title: event.title!, startDate: startDate, endDate: endDate,  liveStream: liveStream!, image: url!)
        }
        return eventResult
    }
    
    //This Function called by parseResults
    func filterString(string: String) -> String
    {
        var filteredString = string.replacingOccurrences(of: "<b>", with: "", options: NSString.CompareOptions.literal, range:nil)
        filteredString = filteredString.replacingOccurrences(of: "</b>", with: "", options: NSString.CompareOptions.literal, range:nil)
        filteredString = filteredString.replacingOccurrences(of: "</br>", with: " ", options: NSString.CompareOptions.literal, range:nil)
        filteredString = filteredString.replacingOccurrences(of: "<br|/>|<div>|<img|</div>|src=", with: "", options: .regularExpression, range:nil)
        return filteredString
    }
    
    //This Function called by parseResults
    func formatDate(date: String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let date = dateFormatter.date(from: date)
        return date!
    }

    //This Function called by parseResults
    func getLocation(stringArray: [String]) -> String?
    {
        var location = ""
        let separatedString = stringArray
        let subString =   separatedString.dropFirst(5)
        for element in subString
        {
            if(element != "Description:") {location = location + " " +  element}
            else {break}
        }
        location = location.trimmingCharacters(in: .whitespacesAndNewlines)
        return location
    }
    
    //This Function called by parseResults
    func getLiveStreamAddress(stringArray: [String]) -> String? //function used for parse Results
    {
        let stringArray = stringArray
        var liveStreamAddress = ""
        for element in stringArray
        {
            if element.range(of:"http://wowza1") != nil
            {
                liveStreamAddress = element
                break
            }
        }
        if(liveStreamAddress != "")
        {
            liveStreamAddress =   String(liveStreamAddress[liveStreamAddress.index(liveStreamAddress.startIndex, offsetBy: 1)])
            liveStreamAddress =   String(liveStreamAddress[..<liveStreamAddress.index(before: liveStreamAddress.endIndex)])
        }
        else {liveStreamAddress = String("https://5ae03111bb852.streamlock.net:4444/External_Feed/BlueTruck/playlist.m3u8")}
        return liveStreamAddress
    }
}//End of UpcomingEventsFeed class
