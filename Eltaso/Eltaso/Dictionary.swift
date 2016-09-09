//
//  Dictionary.swift
//  Eltaso
//
//  Created by 史　翔新 on 2016/07/19.
//  Copyright © 2016年 Crazism. All rights reserved.
//

import Foundation

extension Dictionary {
	
	public init<S: Sequence> (tuples seq: S) where S.Iterator.Element == Element {
		self.init()
		for (k,v) in seq {
			self[k] = v
		}
	}
	
}

extension Dictionary {
	
	public func dropping(_ key: Key) -> Dictionary<Key, Value> {
		var dictionary = self
		dictionary.removeValue(forKey: key)
		return dictionary
	}
	
	public mutating func drop(_ key: Key) {
		self = self.dropping(key)
	}
	
}
