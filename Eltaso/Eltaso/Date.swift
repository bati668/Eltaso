//
//  Date.swift
//  Eltaso
//
//  Created by 史　翔新 on 2016/08/19.
//  Copyright © 2016年 Crazism. All rights reserved.
//

import Foundation

extension Date {
	
	public static func getDateAtSpecificTime(hour: Int = 0, minute: Int = 0, second: Int = 0) throws -> Date {
		
		enum Error: Swift.Error {
			case failedToGetSpecificDateFromCurrentDate
		}
		
		let currentDate = Date()
		let currentCalendar = Calendar.current
		var dateComponents = currentCalendar.dateComponents([.year, .month, .day], from: currentDate)
		dateComponents.hour = hour
		dateComponents.minute = minute
		dateComponents.second = second
		
		guard let specifiedTime = currentCalendar.date(from: dateComponents) else {
			throw Error.failedToGetSpecificDateFromCurrentDate
		}
		
		return specifiedTime
		
	}
	
	public func getDateByAddingInterval(_ interval: Int, toUnit unit: Calendar.Component) throws -> Date {
		
		enum Error: Swift.Error {
			case failedToGetEdittedDateFromCurrentDate
		}
		
		let calendar = Calendar.current
		guard let date = calendar.date(byAdding: unit, value: interval, to: self) else {
			throw Error.failedToGetEdittedDateFromCurrentDate
		}
		
		return date
		
	}
	
}

extension Date {
	
	public func getDateComponents(inTimeZone timeZone: TimeZone = .current) -> DateComponents {
		
		let calendar = Calendar.current
		let components = calendar.dateComponents(in: timeZone, from: self)
		
		return components
		
	}
	
}

extension Date {
	
	public var elapsedTime: TimeInterval {
		
		return -self.timeIntervalSinceNow
		
	}
	
	public func elapsedTime(until date: Date) -> TimeInterval {
		
		return -self.timeIntervalSince(date)
		
	}
	
}
