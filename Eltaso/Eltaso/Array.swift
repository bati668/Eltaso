//
//  Array.swift
//  Eltaso
//
//  Created by 史翔新 on 2016/07/05.
//  Copyright © 2016年 Crazism. All rights reserved.
//

import Foundation

extension Array {
	
	public var shuffled: Array<Element> {
		var array = self
		for i in array.indices.reversed().dropLast() {
			let j = Int.createRandom(within: array.indices.lowerBound ..< i)
			swap(&array[i], &array[j])
		}
		return array
	}
	
	public mutating func shuffle() {
		self = self.shuffled
	}
	
}

extension Array {
	
	public var randomElement: Element? {
		guard self.count > 0 else {
			return nil
		}
		let randomIndex = Int.createRandom(within: self.indices)
		return self[randomIndex]
	}
	
}

extension Array {
	
	public func appending(_ newElement: Element) -> Array<Element> {
		return self + [newElement]
	}
	
	public func appending(_ newElements: [Element]) -> Array<Element> {
		return self + newElements
	}
	
}

extension Array {
	
	public mutating func append(_ newElements: [Element]) {
		self += newElements
	}
	
}

extension Array {
	
	public func keeping(at n: Int) -> Array<Element> {
		let n = n.limited(within: self.indices)
		return [self[n]]
	}
	
	public func keepingFirst(_ n: Int = 1) -> Array<Element> {
		let n = n.limited(within: self.indices)
		return Array(self[0 ..< n])
	}
	
	public func keepingLast(_ n: Int = 1) -> Array<Element> {
		let n = n.limited(within: self.indices)
		return Array(self[(self.count - n) ..< self.count])
	}
	
}

extension Array {
	
	public mutating func keep(at n: Int) {
		self = self.keeping(at: n)
	}
	
	public mutating func keepFirst(_ n: Int = 1) {
		self = self.keepingFirst(n)
	}
	
	public mutating func keepLast(_ n: Int = 1) {
		self = self.keepingLast(n)
	}
	
}

extension Array {
	
	public func removing(at n: Int) -> Array<Element> {
		let n = n.limited(within: self.indices)
		return self.enumerated().reduce([], { (result, tuple) -> Array<Element> in
			return tuple.offset == n ? result : result.appending(tuple.element)
		})
	}
	
	public func removingFirst(_ n: Int = 1) -> Array<Element> {
		let n = n.limited(within: self.indices)
		return Array(self[n ..< self.count])
	}
	
	public func removingLast(_ n: Int = 1) -> Array<Element> {
		let n = n.limited(within: self.indices)
		return Array(self[0 ..< (self.count - n)])
	}
	
}

extension Array {
	
	public mutating func applyForEach(_ transform: (Element) throws -> Element) rethrows {
		
		var result: [Element] = []
		var iterator = self.makeIterator()
		
		while let element = iterator.next() {
			let transformed = try transform(element)
			result.append(transformed)
		}
		
		self = result
		
	}
	
}
