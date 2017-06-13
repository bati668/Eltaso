//
//  Bool.swift
//  Eltaso
//
//  Created by 史翔新 on 2016/07/05.
//  Copyright © 2016年 Crazism. All rights reserved.
//

import Foundation

extension Bool: EltasoCompatible { }

extension EltasoContainer where Containee == Bool {
	
	public static func makeRandom() -> Bool {
		let randomNumber = Int.Eltaso.makeRandom(within: 0 ... 1)
		return randomNumber != 0
	}
	
}

extension EltasoContainer where Containee == Bool {
	
	public var negated: Bool {
		return !self.body
	}
	
	public static func nagate(_ target: inout Bool) {
		target = target.eltaso.negated
	}
	
}
