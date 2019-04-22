///*
//* Copyright 2018 Vinícius Jorge Vendramini
//*
//* Licensed under the Apache License, Version 2.0 (the "License");
//* you may not use this file except in compliance with the License.
//* You may obtain a copy of the License at
//*
//* http://www.apache.org/licenses/LICENSE-2.0
//*
//* Unless required by applicable law or agreed to in writing, software
//* distributed under the License is distributed on an "AS IS" BASIS,
//* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//* See the License for the specific language governing permissions and
//* limitations under the License.
//*/

/// According to http://swiftdoc.org/v4.2/type/Array/hierarchy/
/// (link found via https://www.raywenderlich.com/139591/building-custom-collection-swift)
/// the Array type in Swift conforms exactly to these protocols,
/// plus CustomReflectable (which is beyond Gryphon's scope for now).
public final class ArrayClass<Element>: // kotlin: ignore
	ExpressibleByArrayLiteral, CustomStringConvertible, CustomDebugStringConvertible,
	RandomAccessCollection, MutableCollection, RangeReplaceableCollection
{
	public typealias Buffer = [Element]

	public var array: Buffer

	public init(array: Buffer) {
		self.array = array
	}

	public init<T>(_ arrayReference: ArrayClass<T>) {
		self.array = arrayReference.array as! Buffer
	}

	public func `as`<CastedType>(
		_ type: ArrayClass<CastedType>.Type)
		-> ArrayClass<CastedType>?
	{
		if let castedArray = self.array as? [CastedType] {
			return ArrayClass<CastedType>(array: castedArray)
		}
		else {
			return nil
		}
	}

	public func copy() -> ArrayClass<Element> {
		return ArrayClass(array: array)
	}

	// Expressible By Array Literal
	public typealias ArrayLiteralElement = Element

	public required init(arrayLiteral elements: Element...) {
		self.array = elements
	}

	// ...
	public subscript (_ index: Int) -> Element {
		get {
			return array[index]
		}
		set {
			array[index] = newValue
		}
	}

	// Custom (Debug) String Convertible
	public var description: String {
		return array.description
	}

	public var debugDescription: String {
		return array.debugDescription
	}

	// Collection
	public var startIndex: Int {
		return array.startIndex
	}

	public var endIndex: Int {
		return array.endIndex
	}

	public func index(after i: Int) -> Int {
		return i + 1
	}

	// Bidirectional Collection
	public func index(before i: Int) -> Int {
		return i - 1
	}

	// Range Replaceable Collection
	public func append<S>(contentsOf newElements: S) where S: Sequence, Element == S.Element {
		self.array.append(contentsOf: newElements)
	}

	public required init<S>(_ elements: S) where S: Sequence, Element == S.Element {
		self.array = []
	}

	public required init() {
		self.array = []
	}

	//
	public func append(_ newElement: Element) {
		array.append(newElement)
	}

	public func appending(_ newElement: Element) -> ArrayClass<Element> {
		return ArrayClass<Element>(array: self.array + [newElement])
	}

	public func filter(_ isIncluded: (Element) throws -> Bool) rethrows -> ArrayClass<Element> {
		return try ArrayClass(array: self.array.filter(isIncluded))
	}

	public func map<T>(_ transform: (Element) throws -> T) rethrows -> ArrayClass<T> {
		return try ArrayClass<T>(array: self.array.map(transform))
	}

	public func compactMap<T>(_ transform: (Element) throws -> T?) rethrows -> ArrayClass<T> {
		return try ArrayClass<T>(array: self.array.compactMap(transform))
	}

	public func appending<S>(contentsOf newElements: S) -> ArrayClass<Element>
		where S: Sequence, Element == S.Element
	{
		return ArrayClass<Element>(array: self.array + newElements)
	}

	public func removeFirst() -> Element {
		return array.removeFirst()
	}
}

extension ArrayClass: Equatable where Element: Equatable { // kotlin: ignore
	public static func == (lhs: ArrayClass, rhs: ArrayClass) -> Bool {
		return lhs.array == rhs.array
	}

	//
	public func index(of element: Element) -> Int? {
		return array.index(of: element)
	}
}

extension ArrayClass: Hashable where Element: Hashable { // kotlin: ignore
	public func hash(into hasher: inout Hasher) {
		array.hash(into: &hasher)
	}
}

extension ArrayClass: Codable where Element: Codable { // kotlin: ignore
	public func encode(to encoder: Encoder) throws {
		try array.encode(to: encoder)
	}

	public convenience init(from decoder: Decoder) throws {
		try self.init(array: Buffer(from: decoder))
	}
}

let array1: ArrayClass = [1, 2, 3]
let array2 = array1
array1[0] = 10
print(array1)
print(array2)
print(array2[0])

for i in array1 {
	print(i)
}

for j in array2 {
	print(j)
}

for i in array1 {
	for j in array2 {
		print("\(i), \(j)")
	}
}
