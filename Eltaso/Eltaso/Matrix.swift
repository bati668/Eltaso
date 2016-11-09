//
//  Matrix.swift
//  Eltaso
//
//  Created by 史　翔新 on 2016/10/04.
//  Copyright © 2016年 Crazism. All rights reserved.
//

import Foundation

public enum MatrixInitError: Error {
	case rowsWithDifferentColumns
}

public enum MatrixMathError: Error {
	case sizeMismatch
}

public struct Matrix <Element> {
	
	fileprivate var _value: [Element]
	fileprivate var _columns: Int
	fileprivate var _rows: Int
	
	public typealias Index = (i: Int, j: Int)
	public typealias Size = (m: Int, n: Int)
	public typealias Indices = (rows: CountableRange<Int>, columns: CountableRange<Int>)
	public var size: Size {
		return (self._rows, self._columns)
	}
	public var indices: Indices {
		return (0 ..< self._rows, 0 ..< self._columns)
	}
	
	public init(_ array: [[Element]]) throws {
		let rowCount = array.count
		let columnCount = array.first?.count ?? 0
		for row in array {
			guard row.count == columnCount else {
				throw MatrixInitError.rowsWithDifferentColumns
			}
		}
		self._value = array.flatten
		self._columns = columnCount
		self._rows = rowCount
	}
	
	public init(size: Size, repeatedValue: Element) {
		let elementCount = size.m * size.n
		let elements = (0 ..< elementCount).map { (_) -> Element in
			return repeatedValue
		}
		self._value = elements
		self._columns = size.n
		self._rows = size.m
	}
	
	public subscript(index: Index) -> Element {
		get {
			let i = index.i, j = index.j
			return self[i, j]
		}
		set {
			let i = index.i, j = index.j
			self[i, j] = newValue
		}
	}
	
	public subscript(i: Int, j: Int) -> Element {
		get {
			let index = i * self._columns + j
			return self._value[index]
		}
		set {
			let index = i * self._columns + j
			self._value[index] = newValue
		}
	}
	
	public subscript(row i: Int) -> [Element] {
		return self.indices.columns.map({ (j) -> Element in
			return self[(i, j)]
		})
	}
	
	public subscript(column j: Int) -> [Element] {
		return self.indices.rows.map({ (i) -> Element in
			return self[(i, j)]
		})
	}
	
}

extension Matrix where Element: ExpressibleByIntegerLiteral {
	
	public init(size: Size) {
		self.init(size: size, repeatedValue: 0)
	}
	
}

extension Matrix {
	
	public var isEmpty: Bool {
		return !(self.size.m > 0 && self.size.n > 0)
	}
	
	public var isSquare: Bool {
		return self.size.m == self.size.n
	}
	
}

extension Matrix {
	
	public var transposed: Matrix {
		
		var transposed = self
		transposed._columns = self._rows
		transposed._rows = self._columns
		
		for i in transposed.indices.rows {
			for j in transposed.indices.columns {
				transposed[i, j] = self[j, i]
			}
		}
		
		return transposed
		
	}
	
	public mutating func transpose() {
		self = self.transposed
	}
	
}

extension Matrix {
	
	public func appendingRow(_ row: [Element]) throws -> Matrix<Element> {
		
		guard row.count == self.size.n else {
			throw MatrixMathError.sizeMismatch
		}
		
		var matrix = self
		matrix._value += row
		matrix._rows.increase()
		return matrix
		
	}
	
	public func insertingRow(_ row: [Element], at i: Int) throws -> Matrix<Element> {
		
		guard row.count == self.size.n else {
			throw MatrixMathError.sizeMismatch
		}
		
		var matrix = self
		let initialInsertingIndex = i * self._columns
		row.enumerated().forEach { (j, element) in
			matrix._value.insert(element, at: initialInsertingIndex + j)
		}
		matrix._rows.increase()
		return matrix
		
	}
	
	public mutating func appendRow(_ row: [Element]) throws {
		self = try self.appendingRow(row)
	}
	
	public mutating func insertRow(_ row: [Element], at i: Int) throws {
		self = try self.insertingRow(row, at: i)
	}
	
}

extension Matrix {
	
	public func appendingColumn(_ column: [Element]) throws -> Matrix<Element> {
		
		guard column.count == self.size.m else {
			throw MatrixMathError.sizeMismatch
		}
		
		var matrix = self
		column.enumerated().reversed().forEach { (i, element) in
			matrix._value.insert(element, at: i * self._columns + self._columns)
		}
		matrix._columns.increase()
		
		return matrix
		
	}
	
	public func insertingColumn(_ column: [Element], at j: Int) throws -> Matrix<Element> {
		
		guard column.count == self.size.m else {
			throw MatrixMathError.sizeMismatch
		}
		
		var matrix = self
		column.enumerated().reversed().forEach { (i, element) in
			matrix._value.insert(element, at: i * self._columns + j)
		}
		matrix._columns.increase()
		return matrix
		
	}
	
	public mutating func appendColumn(_ column: [Element]) throws {
		self = try self.appendingColumn(column)
	}
	
	public mutating func insertColumn(_ column: [Element], at j: Int) throws {
		self = try self.insertingColumn(column, at: j)
	}
	
}

extension Matrix {
	
	public func keepingRow(at m: Int) -> Matrix<Element> {
		
		let i = m.limited(within: self.indices.rows)
		
		var matrix = self
		let row = matrix.indices.columns.map({ (j) -> Element in
			return matrix[(i, j)]
		})
		matrix._value = row
		matrix._rows = 1
		
		return matrix
		
	}
	
	public func keepingFirstRows(of m: Int) -> Matrix<Element> {
		
		let m = m.limited(within: 0 ... self.size.m)
		
		var matrix = self
		let rows = (0 ..< m).map { (i) -> [Element] in
			return self.indices.columns.map({ (j) -> Element in
				return matrix[(i, j)]
			})
		}
		matrix._value = rows.flatten
		matrix._rows = m
		
		return matrix
		
	}
	
	public func keepingLastRows(of m: Int) -> Matrix<Element> {
		
		let m = m.limited(within: 0 ... self.size.m)
		
		var matrix = self
		let rows = (self._rows - m ..< self._rows).map { (i) -> [Element] in
			return self.indices.columns.map({ (j) -> Element in
				return matrix[(i, j)]
			})
		}
		matrix._value = rows.flatten
		matrix._rows = m
		
		return matrix
		
	}
	
	public mutating func keepRow(at m: Int) {
		self = self.keepingRow(at: m)
	}
	
	public mutating func keepFirstRows(of m: Int) {
		self = self.keepingFirstRows(of: m)
	}
	
	public mutating func keepLastRows(of m: Int) {
		self = self.keepingLastRows(of: m)
	}
	
}

extension Matrix {
	
	public func keepingColumn(at n: Int) -> Matrix<Element> {
		
		let j = n.limited(within: self.indices.columns)
		
		var matrix = self
		let column = self.indices.rows.map { (i) -> Element in
			return matrix[(i, j)]
		}
		matrix._value = column
		matrix._columns = 1
		
		return matrix
		
	}
	
	public func keepingFirstColumns(of n: Int) -> Matrix<Element> {
		
		let n = n.limited(within: 0 ... self.size.n)
		
		var matrix = self
		let rows = self.indices.rows.map { (i) -> [Element] in
			return (0 ..< n).map({ (j) -> Element in
				return matrix[(i, j)]
			})
		}
		matrix._value = rows.flatten
		matrix._columns = n
		
		return matrix
		
	}
	
	public func keepingLastColumns(of n: Int) -> Matrix<Element> {
		
		let n = n.limited(within: 0 ... self.size.n)
		
		var matrix = self
		let rows = self.indices.rows.map { (i) -> [Element] in
			return (self._columns - n ..< self._columns).map({ (j) -> Element in
				return matrix[(i, j)]
			})
		}
		matrix._value = rows.flatten
		matrix._columns = n
		
		return matrix
		
	}
	
	public mutating func keepColumn(at n: Int) {
		self = self.keepingColumn(at: n)
	}
	
	public mutating func keepFirstColumns(of n: Int) {
		self = self.keepingFirstColumns(of: n)
	}
	
	public mutating func keepLastColumns(of n: Int) {
		self = self.keepingLastColumns(of: n)
	}
	
}

extension Matrix {
	
	public func removingRow(at m: Int) -> Matrix<Element> {
		
		let i = m.limited(within: self.indices.rows)
		
		var matrix = self
		let rows = Array(self.indices.rows).filter { (row) -> Bool in
			return row != i
		}.map { (i) -> [Element] in
			return self.indices.columns.map({ (j) -> Element in
				return matrix[(i, j)]
			})
		}
		matrix._value = rows.flatten
		matrix._rows.decrease()
		
		return matrix
		
	}
	
	public func removingFirstRows(of m: Int) -> Matrix<Element> {
		
		let m = m.limited(within: 0 ... self.size.m)
		
		var matrix = self
		let rows = (self._rows - m ..< self._rows).map { (i) -> [Element] in
			return self.indices.columns.map({ (j) -> Element in
				return matrix[(i, j)]
			})
		}
		matrix._value = rows.flatten
		matrix._rows.decrease(by: m)
		
		return matrix
		
	}
	
	public func removingLastRows(of m: Int) -> Matrix<Element> {
		
		let m = m.limited(within: 0 ... self.size.m)
		
		var matrix = self
		let rows = (0 ..< m).map { (i) -> [Element] in
			return self.indices.columns.map({ (j) -> Element in
				return matrix[(i, j)]
			})
		}
		matrix._value = rows.flatten
		matrix._rows.decrease(by: m)
		
		return matrix
		
	}
	
	public mutating func removeRow(at m: Int) {
		self = self.removingRow(at: m)
	}
	
	public mutating func removeFirstRows(of m: Int) {
		self = self.removingFirstRows(of: m)
	}
	
	public mutating func removeLastRows(of m: Int) {
		self = self.removingLastRows(of: m)
	}
	
}

extension Matrix {
	
	public func removingColumn(at n: Int) -> Matrix<Element> {
		
		let j = n.limited(within: self.indices.columns)
		
		var matrix = self
		let rows = self.indices.rows.map { (i) -> [Element] in
			return Array(self.indices.columns).filter({ (column) -> Bool in
				return column != j
			}).map({ (i) -> Element in
				return matrix[(i, j)]
			})
		}
		matrix._value = rows.flatten
		matrix._columns.decrease()
		
		return matrix
		
	}
	
	public func removingFirstColumns(of n: Int) -> Matrix<Element> {
		
		let n = n.limited(within: 0 ... self.size.n)
		
		var matrix = self
		let rows = self.indices.rows.map { (i) -> [Element] in
			return (n ..< self._columns).map({ (j) -> Element in
				return matrix[(i, j)]
			})
		}
		matrix._value = rows.flatten
		matrix._columns.decrease(by: n)
		
		return matrix
		
	}
	
	public func removingLastColumns(of n: Int) -> Matrix<Element> {
		
		let n = n.limited(within: 0 ... self.size.n)
		
		var matrix = self
		let rows = self.indices.rows.map { (i) -> [Element] in
			return (0 ..< self._columns - n).map({ (j) -> Element in
				return matrix[(i, j)]
			})
		}
		matrix._value = rows.flatten
		matrix._columns.decrease(by: n)
		
		return matrix
		
	}
	
	public mutating func removeColumn(at n: Int) {
		self = self.removingColumn(at: n)
	}
	
	public mutating func removeFirstColumns(of n: Int) {
		self = self.removingFirstColumns(of: n)
	}
	
	public mutating func removeLastColumns(of n: Int) {
		self = self.removingLastColumns(of: n)
	}
	
}

extension Matrix: CustomStringConvertible {
	
	public var description: String {
		let sizeText = "m: \(self.size.m), n: \(self.size.n)"
		let rows = self.indices.rows.map { (i) -> String in
			return self.indices.columns.reduce("", { (result, j) -> String in
				return result + "\(self[(i, j)])" + ", "
			})
		}
		return sizeText + "\n" + rows.reduce("", { (result, row) -> String in
			return result + row + "\n"
		})
	}
	
}

public func + <T> (lhs: Matrix<T>, rhs: Matrix<T>) throws -> Matrix<T> where T: AdditionOperatable {
	
	guard lhs.size == rhs.size else {
		throw MatrixMathError.sizeMismatch
	}
	
	var matrix = lhs
	for i in matrix.indices.rows {
		for j in matrix.indices.columns {
			matrix[i, j] += rhs[i, j]
		}
	}
	
	return matrix
	
}

public func += <T> (lhs: inout Matrix<T>, rhs: Matrix<T>) throws where T: AdditionOperatable {
	lhs = try lhs + rhs
}

public func - <T> (lhs: Matrix<T>, rhs: Matrix<T>) throws -> Matrix<T> where T: SubtractionOperatable {
	
	guard lhs.size == rhs.size else {
		throw MatrixMathError.sizeMismatch
	}
	
	var matrix = lhs
	for i in matrix.indices.rows {
		for j in matrix.indices.columns {
			matrix[i, j] -= rhs[i, j]
		}
	}
	
	return matrix
	
}

public func -= <T> (lhs: inout Matrix<T>, rhs: Matrix<T>) throws where T: SubtractionOperatable {
	lhs = try lhs - rhs
}

public func * <T> (lhs: Matrix<T>, rhs: Matrix<T>) throws -> Matrix<T> where T: AdditionOperatable, T: MultiplicationOperatable {
	
	guard lhs.size.n == rhs.size.m else {
		throw MatrixMathError.sizeMismatch
	}
	
	let resultSize: Matrix<T>.Size = (lhs.size.m, rhs.size.n)
	let resultIndices: Matrix<T>.Indices = (lhs.indices.rows, rhs.indices.columns)
	let resultElementFactorIndices: CountableRange<Int> = lhs.indices.columns
	
	print(resultSize)
	print(resultIndices)
	print(resultElementFactorIndices)
	
	func getMultipliedValue(at index: Matrix<T>.Index) -> T {
		return resultElementFactorIndices.reduce(T.additionOperationInitialValue) { (result, indice) -> T in
			let factor = lhs[index.i, indice] * rhs[indice, index.j]
			return result + factor
		}
	}
	
	let value = resultIndices.rows.map { (i) -> [T] in
		return resultIndices.columns.map({ (j) -> T in
			return getMultipliedValue(at: (i, j))
		})
	}
	
	return try Matrix(value)
	
}

public func * <T> (lhs: T, rhs: Matrix<T>) -> Matrix<T> where T: MultiplicationOperatable {
	
	var matrix = rhs
	for j in matrix.indices.rows {
		for i in matrix.indices.columns {
			matrix[i, j] *= lhs
		}
	}
	return matrix
	
}

public func * <T> (lhs: Matrix<T>, rhs: T) -> Matrix<T> where T: MultiplicationOperatable {
	return rhs * lhs
}

public func *= <T> (lhs: inout Matrix<T>, rhs: Matrix<T>) throws where T: AdditionOperatable, T: MultiplicationOperatable {
	lhs = try lhs * rhs
}

public func *= <T> (lhs: inout Matrix<T>, rhs: T) where T: MultiplicationOperatable {
	lhs = lhs * rhs
}

public func == <T> (lhs: Matrix<T>, rhs: Matrix<T>) -> Bool where T: Equatable {
	
	guard lhs.size == rhs.size else {
		return false
	}
	
	for i in 0 ..< lhs.size.n {
		for j in 0 ..< lhs.size.m {
			if lhs[i, j] != rhs[i, j] {
				return false
			}
		}
	}
	
	return true
	
}

public func != <T> (lhs: Matrix<T>, rhs: Matrix<T>) -> Bool where T: Equatable {
	return !(lhs == rhs)
}
