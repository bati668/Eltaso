//
//  NSTimeInterval.swift
//  Eltaso
//
//  Created by 史　翔新 on 2016/07/19.
//  Copyright © 2016年 Crazism. All rights reserved.
//

import Foundation

public extension NSTimeInterval {
	
	public var timeFormattedDescription: String {
		var seconds = Int(self)
		
		var minutes = seconds / 60
		seconds = seconds % 60
		
		var hours = minutes / 60
		minutes = minutes % 60
		
		let days = hours / 24
		hours = hours % 24
		
		if days > 0 {
			return "\(days) 日 \(hours) 時間 \(minutes) 分 \(seconds) 秒"
			
		} else if hours > 0 {
			return "\(hours) 時間 \(minutes) 分 \(seconds) 秒"
			
		} else if minutes > 0 {
			return "\(minutes) 分 \(seconds) 秒"
			
		} else {
			return "\(seconds) 秒"
		}
		
	}
	
	public static let minuteLength: NSTimeInterval = 60
	public static let hourLength: NSTimeInterval = .minuteLength * 60
	public static let dayLength: NSTimeInterval = .hourLength * 24
	public static let weekLength: NSTimeInterval = .dayLength * 7
	
	public static func estimatedTime(since baseTime: NSDate) -> NSTimeInterval {
		return -baseTime.timeIntervalSinceNow
	}
	
}
