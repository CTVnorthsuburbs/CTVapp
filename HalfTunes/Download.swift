//
//  Download.swift
//  HalfTunes
//
//  Created by William Ogura on 7/8/16.
//
//
//  Updated by Charlie Rooney July 27th 2018
//

import Foundation

class Download: NSObject
{
    var url: String
    var isDownloading = false
    var progress: Float = 0.0
    var downloadTask: URLSessionDownloadTask?
    var resumeData: Data?
    init(url: String){self.url = url}
}//class Download
